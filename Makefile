STAGEDIR ?= "$(SNAPCRAFT_STAGE)"
DESTDIR ?= "$(CURDIR)/install"

all: boot install

boot:
	if [ -f $(STAGEDIR)/usr/lib/shim/shimx64.efi.signed.latest ]; then \
		cp $(STAGEDIR)/usr/lib/shim/shimx64.efi.signed.latest shim.efi.signed; \
	elif [ -f $(STAGEDIR)/usr/lib/shim/shimx64.efi.signed ]; then \
		cp $(STAGEDIR)/usr/lib/shim/shimx64.efi.signed shim.efi.signed; \
	else \
		exit 1; \
	fi
	cp $(STAGEDIR)/usr/lib/shim/BOOTX64.CSV BOOTX64.CSV
	cp $(STAGEDIR)/usr/lib/shim/fbx64.efi fbx64.efi
	cp $(STAGEDIR)/usr/lib/shim/mmx64.efi mmx64.efi
	cp $(STAGEDIR)/usr/lib/grub/x86_64-efi-signed/grubx64.efi.signed grubx64.efi

install: boot
	mkdir -p $(DESTDIR)
	install -m 644 shim.efi.signed BOOTX64.CSV fbx64.efi mmx64.efi grubx64.efi $(DESTDIR)/
	install -m 644 grub.cfg $(DESTDIR)/
	# For classic builds we also need to prime the gadget.yaml
	mkdir -p $(DESTDIR)/meta
	cp gadget.yaml $(DESTDIR)/meta/
