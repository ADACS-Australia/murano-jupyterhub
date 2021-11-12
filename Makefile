TARGET=jupyterhub
.PHONY: $(TARGET).zip

# all: update-image-id $(TARGET).zip

build: write-version $(TARGET).zip

clean:
	rm -rf $(TARGET).zip

# Don't count on this... murano-pkg-check is very outdated, sadly
check: $(TARGET).zip
	murano-pkg-check --ignore W082,W100 $<

upload: check
	murano package-import -c "Application Servers" --exists-action u $(TARGET).zip

# public:
# 	@echo "Searching for $(TARGET) package ID..."
# 	@package_id=$$(murano package-list --fqn $(TARGET) | grep $(TARGET) | awk '{print $$2}'); \
# 	echo "Found ID: $$package_id"; \
# 	murano package-update --is-public true $$package_id

update-image-id:
	@image_name="ADACS The Littlest JupyterHub (Ubuntu 20.04 LTS Focal)"; \
	echo "Searching for latest image of $$image_name..."; \
	image_id=$$(openstack image list --limit 100 --long -f value -c ID -c Project --property "name=$$image_name" --sort created_at | tail -n1 | cut -d" " -f1); \
	if [ -z "$$image_id" ]; then \
		echo "Image ID not found"; exit 1; \
	fi; \
    echo "Found ID: $$image_id"; \
    sed -i''".bak" "s/image:.*/image: $$image_id/g" $(TARGET)/UI/ui.yaml; \
    rm $(TARGET)/UI/ui.yaml.bak

write-version:
	@version=$$(cat VERSION); \
	echo "Writing version: $$version in manifest"; \
	sed -i''".bak" "s/\[v.*\]/\[v$$version\]/g" $(TARGET)/manifest.yaml; \
	rm $(TARGET)/manifest.yaml.bak

$(TARGET).zip:
	rm -f $@; cd $(TARGET); zip ../$@ -r *; cd ..
