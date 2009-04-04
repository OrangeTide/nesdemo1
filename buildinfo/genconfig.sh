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

if [ \! -e "$(which pkg-config)" ]; then
	echo "You need pkg-config installed. http://www.macports.org/"
	exit 1
fi

case "$OS" in
	Darwin)
		find_darwin_sdk
		X11_CFLAGS="-I/usr/include/"
		X11_LDFLAGS="-L/usr/X11R6/lib -lX11 -lXext"
		FT2_CFLAGS="-I/usr/include/"
		FT2_LDFLAGS="-L/usr/X11R6/lib -lfreetype -lz"
	;;
	*)
		if pkg-config x11 && pkg-config xext ; then 
			X11_INSTALLED=yes
			X11_CFLAGS=$(pkg-config --cflags x11 xext)
			X11_LDFLAGS=$(pkg-config --libs x11 xext)
		else
			X11_INSTALLED=no
		fi

		# try freetype
		if pkg-config freetype2 ; then 
			FT2_INSTALLED=yes
			FT2_CFLAGS=$(pkg-config --cflags freetype2)
			FT2_LDFLAGS=$(pkg-config --libs freetype2)
		else
			FT2_INSTALLED=no
		fi
	;;
esac

if pkg-config cairo ; then 
	CAIRO_INSTALLED=yes
	CAIRO_VERSION=$(pkg-config --modversion cairo)
	CAIRO_CFLAGS=$(pkg-config --cflags cairo pixman-1 freetype2)
	CAIRO_LDFLAGS=$(pkg-config --libs cairo pixman-1 freetype2)
else
	CAIRO_INSTALLED=no
fi

if pkg-config libpng ; then 
	LIBPNG_INSTALLED=yes
	LIBPNG_VERSION=$(pkg-config --modversion libpng)
	LIBPNG_CFLAGS=$(pkg-config --cflags libpng)
	LIBPNG_LDFLAGS=$(pkg-config --libs libpng)
else
	LIBPNG_INSTALLED=no
fi

if [ $? -ne 0 ]; then
	echo $0:failed
	exit 1
fi

cat >${CONF} <<EOF
## X11
X11_INSTALLED:=${X11_INSTALLED}
X11_CFLAGS:=${X11_CFLAGS}
X11_LDFLAGS:=${X11_LDFLAGS}

## Freetype2
FT2_INSTALLED:=${FT2_INSTALLED}
FT2_CFLAGS:=${FT2_CFLAGS}
FT2_LDFLAGS:=${FT2_LDFLAGS}

## Cairo
CAIRO_INSTALLED:=${CAIRO_INSTALLED}
CAIRO_CFLAGS:=${CAIRO_CFLAGS}
CAIRO_LDFLAGS:=${CAIRO_LDFLAGS}

## Libpng
LIBPNG_INSTALLED:=${LIBPNG_INSTALLED}
LIBPNG_CFLAGS:=${LIBPNG_CFLAGS}
LIBPNG_LDFLAGS:=${LIBPNG_LDFLAGS}
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
