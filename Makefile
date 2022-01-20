TARGET=jupyterhub
PKG=$(TARGET).zip
.PHONY: $(PKG)

build: update-image-id write-version $(PKG)

clean:
	rm -rf $(PKG)

# Don't count on this... murano-pkg-check is very outdated, sadly
check: build
	murano-pkg-check --ignore W082,W100 $(PKG)

IMAGE_NAME=ADACS The Littlest JupyterHub (Ubuntu 20.04 LTS Focal)
update-image-id:
	@echo "Searching for latest version of image: $(IMAGE_NAME)..."
	@image_id=$$(openstack image list --community --limit 100 --long -f value -c ID -c Project --property "name=$(IMAGE_NAME)" --sort created_at | tail -n1 | cut -d" " -f1); \
	if [ -z "$$image_id" ]; then \
		echo "Image ID not found"; exit 1; \
	fi; \
    echo "Found ID: $$image_id";\
    sed -i''".bak" "s/image:.*/image: $$image_id/g" $(TARGET)/UI/ui.yaml; \
    rm $(TARGET)/UI/ui.yaml.bak

upload: check
	murano package-import -c "Application Servers" --exists-action u $(PKG)

write-version:
	@version=$$(cat VERSION); \
	echo "Writing version: $$version in manifest"; \
	sed -i''".bak" "s/\[v.*\]/\[v$$version\]/g" $(TARGET)/manifest.yaml; \
	rm $(TARGET)/manifest.yaml.bak

$(PKG):
	rm -f $@; cd $(TARGET); zip ../$@ -r *; cd ..
