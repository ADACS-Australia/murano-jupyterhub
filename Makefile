TARGET=jupyterhub
.PHONY: $(TARGET).zip

build: write-version $(TARGET).zip

clean:
	rm -rf $(TARGET).zip

# Don't count on this... murano-pkg-check is very outdated, sadly
check: $(TARGET).zip
	murano-pkg-check --ignore W082,W100 $<

upload: check
	murano package-import -c "Application Servers" --exists-action u $(TARGET).zip

write-version:
	@version=$$(cat VERSION); \
	echo "Writing version: $$version in manifest"; \
	sed -i''".bak" "s/\[v.*\]/\[v$$version\]/g" $(TARGET)/manifest.yaml; \
	rm $(TARGET)/manifest.yaml.bak

$(TARGET).zip:
	rm -f $@; cd $(TARGET); zip ../$@ -r *; cd ..
