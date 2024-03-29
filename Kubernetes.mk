.PHONY : k8s-minikube-volume k8s-registry

KUBECTL ?= $(shell command -v kubectl 2> /dev/null || echo kubectl)
KUSTOMIZE ?= $(shell command -v kustomize 2> /dev/null || echo kustomize)
VBOX_MANAGE ?= $(shell command -v VBoxManage 2> /dev/null || echo VBoxManage)

MINIKUBE ?= $(shell command -v minikube 2> /dev/null || echo minikube)
k8s-minikube-volume:
	-$(MINIKUBE) ssh -- sudo umount $(MINIKUBE_VOLUME_REF)
	-$(VBOX_MANAGE) sharedfolder add minikube --name $(MINIKUBE_VOLUME_REF) --hostpath $(LOCAL_PATH) --transient
	$(MINIKUBE) ssh -- sudo mount -t vboxsf $(MINIKUBE_VOLUME_REF) $(MINIKUBE_PATH)

# Support variable renaming to drop the dash from it
K8S_RESOURCES ?= $(K8S-RESOURCES)
k8s-down: $(K8S_RESOURCES)
	$(KUSTOMIZE) build $(K8S_RESOURCES) | $(KUBECTL) delete -f -

k8s-up: $(K8S_RESOURCES)
	$(KUSTOMIZE) build $(K8S_RESOURCES) | $(KUBECTL) apply -f -

k8s_minikube_open_service = $(MINIKUBE) service $(1)

k8s_jump = $(KUBECTL) port-forward svc/$(1) $(2):$(3)

k8s_exec = $(KUBECTL) exec -i $(3) $(1) -- $(2)

k8s-registry:
ifeq ($(REGISTRY_USERNAME),)
	$(error You need to setup your registry's username in the .env file first)
endif
ifeq ($(REGISTRY_TOKEN),)
	$(error You need to setup your registry's token in the .env file first)
endif
	$(KUBECTL) create \
		secret \
		docker-registry \
		$(REGISTRY_NAME) \
		--docker-server=$(REGISTRY_URL) \
		--docker-username=$(REGISTRY_USERNAME) \
		--docker-password=$(REGISTRY_TOKEN)
