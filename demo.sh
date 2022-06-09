#!/usr/bin/env bash
set -e -u -o pipefail

declare -r SCRIPT_DIR=$(cd -P $(dirname $0) && pwd)

declare -r NAMESPACE=${NAMESPACE:-apimatic-codegen-openshift-demo}

_log() {
    local level=$1; shift
    echo -e "$level: $@"
}

log.err() {
    _log "ERROR" "$@" >&2
}

info() {
    _log "\nINFO" "$@"
}

err() {
    local code=$1; shift
    local msg="$@"; shift
    log.err $msg
    exit $code
}

valid_command() {
  local fn=$1; shift
  [[ $(type -t "$fn") == "function" ]]
}

# helpers to avoid adding -n $NAMESPACE to oc and tkn
OC() {
  echo oc -n "$NAMESPACE" "$@"
  oc -n "$NAMESPACE" "$@"
}

TKN() {
 echo tkn -n "$NAMESPACE" "$@"
 tkn -n "$NAMESPACE" "$@"
}

demo.validate_tools() {
  info "validating tools"

  tkn version >/dev/null 2>&1 || err 1 "no tkn binary found"
  oc version  >/dev/null 2>&1 || err 1 "no oc binary found"
  return 0
}

demo.webhook-url(){
  local route=$(oc -n $NAMESPACE get route  -l eventlistener=apimatic-codegen-operator-demo -o name )
  local url=$(oc -n $NAMESPACE get $route --template='http://{{.spec.host}}')
  info "Webook URL: $url "
}

bootstrap() {
    demo.validate_tools

    info "ensure namespace $NAMESPACE exists"
    OC get ns "$NAMESPACE" 2>/dev/null  || {
      OC new-project $NAMESPACE
    }
  }

demo.setup-triggers() {
  local run_bootstrap=${1:-"run"}
  [[ "$run_bootstrap" == "skip-bootstrap" ]] || bootstrap

  info "Setup Triggers"
  OC apply -f .tekton/Triggers/binding.yaml
  OC apply -f .tekton/Triggers/trigger.yaml
  sed -e "s|pipelines-tutorial|$NAMESPACE|g" .tekton/Triggers/template.yaml | OC apply -f -

  info "Setup Event Listener"
  OC apply -f .tekton/Triggers/event_listener.yaml

  sleep 3
  info "Expose event listener"
  local el_svc=$(oc -n $NAMESPACE get svc -l eventlistener=apimatic-codegen-operator-demo -o name)
  OC expose $el_svc

  sleep 5
  demo.webhook-url
}


demo.setup-pipeline() {
  local run_bootstrap=${1:-"run"}
  [[ "$run_bootstrap" == "skip-bootstrap" ]] || bootstrap

  info "Apply pipeline tasks"
  OC apply -f .tekton/Pipeline/apply_manifest_task.yaml
  OC apply -f .tekton/Pipeline/update_deployment_task.yaml

  info "Creating workspace"
  OC apply -f .tekton/Pipeline/persistent_volume_claim.yaml

  info "Applying pipeline"
  OC apply -f .tekton/Pipeline/pipeline.yaml

  echo -e "\nPipeline"
  echo "==============="
  TKN p desc build-and-deploy

}

demo.setup() {
  bootstrap
  demo.setup-pipeline skip-bootstrap
  demo.setup-triggers skip-bootstrap
}

demo.logs() {
  TKN pipeline logs build-and-deploy --last -f
}

demo.run() {
  info "Running DX Portal Build and deploy"
  TKN pipeline start build-and-deploy \
    -w name=shared-workspace,volumeClaimTemplateFile=.tekton/Pipeline/persistent_volume_claim.yaml \
    -p deployment-name=apimatic-dx-portal-demo \
    -p git-url=https://github.com/Obaid-Rehman/apimatic-codegen-openshift-pipelines-demo.git \
    -p IMAGE="image-registry.openshift-image-registry.svc:5000/${NAMESPACE}/apimatic-dx-portal" \
    --use-param-defaults \
    --showlog=true

  info "Validating the result of pipeline run"
  demo.validate_pipelinerun
}

demo.validate_pipelinerun() {
  local failed=0
  local results=( $(oc get pipelinerun.tekton.dev -n "$NAMESPACE" --template='
    {{range .items -}}
      {{ $pr := .metadata.name -}}
      {{ $c := index .status.conditions 0 -}}
      {{ $pr }}={{ $c.type }}{{ $c.status }}
    {{ end }}
    ') )

  for result in ${results[@]}; do
    if [[ ! "${result,,}" == *"=succeededtrue" ]]; then
      echo "ERROR: test $result but should be SucceededTrue"
      failed=1
    fi
  done

  return "$failed"
}

demo.url() {
  echo "Click following URL to access the application"
  oc -n "$NAMESPACE" get route apimatic-dx-portal --template='http://{{.spec.host}} '
  echo
}


demo.help() {
# NOTE: must insert leading TABS and not SPACE to align
  cat <<-EOF
		USAGE:
		  demo [command]

		COMMANDS:
		  setup             runs both pipeline and trigger setup
		  setup-pipeline    sets up project, tasks, pipeline and workspace
		  setup-triggers    sets up  trigger, trigger-template, bindings, event-listener, expose webhook url
		  run               starts pipeline to deploy api, ui
		  webhook-url       provides the webhook url, which listens to github-event payloads
		  logs              shows logs of last pipelinerun
		  url               provides the url of the application
EOF
}

main() {
  local fn="demo.${1:-help}"
  valid_command "$fn" || {
    demo.help
    err  1 "invalid command '$1'"
  }

  cd "$SCRIPT_DIR"
  $fn "$@"
  return $?
}

main "$@"
