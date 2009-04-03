#!/bin/sh
CONF=config-local.mk
OS=$(uname -s)

find_darwin_sdk()
{
	for i in \
		"${DARWIN_SDK}" \
		/Developer/SDKs/MacOSX10.5.sdk \
		/Developer/SDKs/MacOSX10.4u.sdk \
		/Developer/SDKs/MacOSX10.3.9.sdk \
	; do
		if [ -n "$i" -a -d "$i" ]; then
			DARWIN_SDK="$i"
			MACOSX_DEPLOYMENT_TARGET=$(echo "$i" | sed -e 's/.*MacOSX\([0-9]*\.[0-9]*\).*$/\1/')
			return
		fi
	done

	echo "Could not find Darwin SDK. Try editing $0 or setting DARWIN_SDK"
	exit 1
}

case "$OS" in
	Darwin)
		find_darwin_sdk
		X11_CFLAGS="-I/usr/include/"
		X11_LDFLAGS="-L/usr/X11R6/lib -lX11 -lXext"
		FT2_CFLAGS="-I/usr/include/"
		FT2_LDFLAGS="-L/usr/X11R6/lib -lfreetype -lz"
		if [ \! -e "$(which pkg-config)" ]; then
			echo "You need pkg-config installed. http://www.macports.org/"
			exit 1
		fi
		CAIRO_CFLAGS=$(pkg-config --cflags cairo pixman-1 freetype2)
		CAIRO_LDFLAGS=$(pkg-config --libs cairo pixman-1 freetype2)
	;;
	*)
		X11_CFLAGS=$(pkg-config --cflags x11 xext)
		X11_LDFLAGS=$(pkg-config --libs x11 xext)
		FT2_CFLAGS=$(pkg-config --cflags freetype2)
		FT2_LDFLAGS=$(pkg-config --libs freetype2)
		CAIRO_CFLAGS=$(pkg-config --cflags cairo pixman-1 freetype2)
		CAIRO_LDFLAGS=$(pkg-config --libs cairo pixman-1 freetype2)
	;;
esac

if [ $? -ne 0 ]; then
	echo $0:failed
	exit 1
fi

cat >${CONF} <<EOF
## X11
X11_CFLAGS:=${X11_CFLAGS}
X11_LDFLAGS:=${X11_LDFLAGS}

## Freetype2
FT2_CFLAGS:=${FT2_CFLAGS}
FT2_LDFLAGS:=${FT2_LDFLAGS}

## Cairo
CAIRO_CFLAGS:=${CAIRO_CFLAGS}
CAIRO_LDFLAGS:=${CAIRO_LDFLAGS}
EOF

# on OSX systems use the isysroot to select the SDK
if [ -n "${DARWIN_SDK}" ]; then
cat >>${CONF} <<EOF

## Darwin
MACOSX_DEPLOYMENT_TARGET:=${MACOSX_DEPLOYMENT_TARGET}
export MACOSX_DEPLOYMENT_TARGET
DARWIN_SDK:="${DARWIN_SDK}"
# excessive warnings - breaks on some OSes
CFLAGS:=\$(filter-out -Wconversion,\$(CFLAGS))
CFLAGS+=-isysroot \$(DARWIN_SDK)
LDFLAGS+=-isysroot \$(DARWIN_SDK)
EOF
fi
