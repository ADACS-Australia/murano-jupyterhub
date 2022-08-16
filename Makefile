TARGET=jupyterhub
PKG=$(TARGET).zip
.PHONY: $(PKG)

build: write-version $(PKG)

clean:
	rm -rf $(PKG)

# Don't count on this... murano-pkg-check is very outdated, sadly
check: build
	murano-pkg-check --ignore W082,W100 $(PKG)

upload: check
	murano package-import -c "Application Servers" --exists-action u $(PKG)

write-version:
	@version=$$(cat VERSION); \
	echo "Writing version: $$version in manifest"; \
	sed -i''".bak" "s/\[v.*\]/\[v$$version\]/g" $(TARGET)/manifest.yaml; \
	rm $(TARGET)/manifest.yaml.bak

$(PKG):
	rm -f $@; cd $(TARGET); zip ../$@ -r *; cd ..
