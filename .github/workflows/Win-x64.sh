#!/usr/bin/env bash
#Made by @Cryptiiiic, Cryptic#6293
set -e
export FR_BASE=/tmp/build
export PATH=/clang64/bin:/mingw64/x86_64-w64-mingw32/bin:/mingw64/bin:${PATH}
export TOOLCHAIN_PREFIX=llvm-
export C_ARGS="-fPIC"
export CXX_ARGS="-fPIC"
export LD_ARGS="-Wl,--allow-multiple-definition -static -all-static -L/usr/lib/x86_64-linux-gnu -L/tmp/out/lib -L/mingw64/x86_64-w64-mingw32/lib -L/mingw64/lib"
export C_ARGS2="-fPIC"
export CXX_ARGS2="-fPIC"
export LD_ARGS2="-Wl,--allow-multiple-definition -L/usr/lib/x86_64-linux-gnu -L/tmp/out/lib -L/mingw64/x86_64-w64-mingw32/lib -L/mingw64/lib"
export PKG_CFG="/tmp/out/lib/pkgconfig"
export CC_ARGS="CC=/mingw64/bin/clang.exe CXX=/mingw64/bin/clang++.exe LD=/mingw64/x86_64-w64-mingw32/bin/ld.exe AR=/mingw64/x86_64-w64-mingw32/bin/ar.exe AS=/mingw64/x86_64-w64-mingw32/bin/as.exe RANLIB=/mingw64/x86_64-w64-mingw32/bin/ranlib.exe DLLTOOL=/mingw64/x86_64-w64-mingw32/bin/dlltool.exe DSYMUTIL=/clang64/bin/dsymutil"
export CONF_ARGS="--prefix=/tmp/out --disable-dependency-tracking --disable-silent-rules --disable-debug --without-debug --without-cython --enable-static=yes --enable-shared=no --disable-shared"
export NPROC=$(expr $(nproc) / 2)
export JNUM="-j${NPROC}"
export LNUM="-l${NPROC}"
export CMAKE_ARGS="-DCMAKE_BUILD_TYPE=Release -DCMAKE_CROSSCOMPILING=false -DCMAKE_INSTALL_PREFIX=/tmp/out -DBUILD_SHARED_LIBS=0 -DCMAKE_C_COMPILER=/mingw64/bin/clang.exe -DCMAKE_CXX_COMPILER=/mingw64/bin/clang++.exe -DCMAKE_C_LINK_EXECUTABLE=/mingw64/x86_64-w64-mingw32/bin/ld.exe -DCMAKE_CXX_LINK_EXECUTABLE=/mingw64/x86_64-w64-mingw32/bin/ld.exe -DWIN32=1 -D_WIN32=1 -Wno-dev"
export CMAKE="cmake $CC_ARGS $CMAKE_ARGS"
export MAKE="make ${JNUM} ${LNUM}"
export script_timer_start=$(date +%s)
export DIR=$(pwd)

function setupDIR () {
    echo "Setting up build location and permissions"
    # rm -rf ${FR_BASE} || true
    mkdir ${FR_BASE} || true
#    chown -R 0:0 ${FR_BASE}
    cd ${FR_BASE}
    echo "Done"
}

function getAPTDeps () {
    echo "Downloading pacman deps"
    sed -i "s/db //g" /etc/nsswitch.conf
    sed -i "s/\#SigLevel = Optional TrustAll/SigLevel = Never/g" /etc/pacman.conf
    sed -i "s/SigLevel    = Required DatabaseOptional/SigLevel = Never/g" /etc/pacman.conf
    sed -i "s/LocalFileSigLevel = Optional/LocalFileSigLevel = Never/g" /etc/pacman.conf
    sed -i "s/#RemoteFileSigLevel = Optional/RemoteFileSigLevel = Never/g" /etc/pacman.conf
#    pacman -Syyu
#    pacman-cross -S --needed --noconfirm --ignore texinfo mingw-w64-x86_64-clang msys2-devel base-devel mingw-w64-x86_64-pkg-config mingw-w64-x86_64-bzip2 msys2-runtime-devel mingw-w64-x86_64-libusb mingw-w64-x86_64-readline curl make bash automake autoconf cmake pkgconf pkg-config openssl mingw-w64-x86_64-gnutls libtool m4 git zstd
#    cp -RpP /windows ${DIR}/windows
    git config --global init.defaultBranch master
    echo "Done"
}

function cloneRepos () {
    echo "Cloning git repos and other deps"
    mkdir ${FR_BASE}/openssl
    cd ${FR_BASE}/openssl
    git init
    git remote add -t openssl-3.0 origin https://github.com/openssl/openssl.git
    git fetch origin openssl-3.0
    git reset --hard FETCH_HEAD
#    mkdir ${FR_BASE}/curl
#    cd ${FR_BASE}/curl
#    git init
#    git remote add -t curl-7_78_0 origin https://github.com/curl/curl.git
#    git fetch origin curl-7_78_0
#    git reset --hard FETCH_HEAD
#    mkdir ${FR_BASE}/libpng
#    cd ${FR_BASE}/libpng
#    git init
#    git remote add -t libpng16 origin https://github.com/glennrp/libpng.git
#    git fetch origin libpng16
#    git reset --hard FETCH_HEAD
#    mkdir ${FR_BASE}/xpwn
#    cd ${FR_BASE}/xpwn
#    git init
#    git remote add -t master origin https://github.com/nyuszika7h/xpwn.git
#    git fetch origin master
#    git reset --hard FETCH_HEAD
#    mkdir ${FR_BASE}/libzip
#    cd ${FR_BASE}/libzip
#    git init
#    git remote add -t master origin https://github.com/nih-at/libzip.git
#    git fetch origin master
#    git reset --hard FETCH_HEAD
#    mkdir ${FR_BASE}/lzfse
#    cd ${FR_BASE}/lzfse
#    git init
#    git remote add -t master origin https://github.com/lzfse/lzfse.git
#    git fetch origin master
#    git reset --hard FETCH_HEAD
#    mkdir ${FR_BASE}/libplist
#    cd ${FR_BASE}/libplist
#    git init
#    git remote add -t master origin https://github.com/libimobiledevice/libplist.git
#    git fetch origin master
#    git reset --hard FETCH_HEAD
#    mkdir ${FR_BASE}/libimobiledevice-glue
#    cd ${FR_BASE}/libimobiledevice-glue
#    git init
#    git remote add -t master origin https://github.com/libimobiledevice/libimobiledevice-glue.git
#    git fetch origin master
#    git reset --hard FETCH_HEAD
#    mkdir ${FR_BASE}/libusbmuxd
#    cd ${FR_BASE}/libusbmuxd
#    git init
#    git remote add -t master origin https://github.com/libimobiledevice/libusbmuxd.git
#    git fetch origin master
#    git reset --hard FETCH_HEAD
#    mkdir ${FR_BASE}/libimobiledevice
#    cd ${FR_BASE}/libimobiledevice
#    git init
#    git remote add -t master origin https://github.com/libimobiledevice/libimobiledevice.git
#    git fetch origin master
#    git reset --hard FETCH_HEAD
#    mkdir ${FR_BASE}/libirecovery
#    cd ${FR_BASE}/libirecovery
#    git init
#    git remote add -t master origin https://github.com/libimobiledevice/libirecovery.git
#    git fetch origin master
#    git reset --hard FETCH_HEAD
#    mkdir ${FR_BASE}/libgeneral
#    cd ${FR_BASE}/libgeneral
#    git init
#    git remote add -t master origin https://github.com/tihmstar/libgeneral.git
#    git fetch origin master
#    git reset --hard FETCH_HEAD
#    mkdir ${FR_BASE}/img4tool
#    cd ${FR_BASE}/img4tool
#    git init
#    git remote add -t master origin https://github.com/tihmstar/img4tool.git
#    git fetch origin master
#    git reset --hard FETCH_HEAD
#    mkdir ${FR_BASE}/libinsn
#    cd ${FR_BASE}/libinsn
#    git init
#    git remote add -t master origin https://github.com/tihmstar/libinsn.git
#    git fetch origin master
#    git reset --hard FETCH_HEAD
#    mkdir ${FR_BASE}/libfragmentzip
#    cd ${FR_BASE}/libfragmentzip
#    git init
#    git remote add -t master origin https://github.com/tihmstar/libfragmentzip.git
#    git fetch origin master
#    git reset --hard FETCH_HEAD
#    mkdir ${FR_BASE}/liboffsetfinder64
#    cd ${FR_BASE}/liboffsetfinder64
#    git init
#    git remote add -t main origin https://github.com/Cryptiiiic/liboffsetfinder64.git
#    git fetch origin main
#    git reset --hard FETCH_HEAD
#    mkdir ${FR_BASE}/libipatcher
#    cd ${FR_BASE}/libipatcher
#    git init
#    git remote add -t main origin https://github.com/Cryptiiiic/libipatcher.git
#    git fetch origin main
#    git reset --hard FETCH_HEAD
#    git submodule init && git submodule update --recursive
#    mkdir ${FR_BASE}/futurerestore
#    cd ${FR_BASE}/futurerestore
#    git init
#    git remote add -t test origin https://github.com/m1stadev/futurerestore.git
#    git fetch origin test
#    git reset --hard FETCH_HEAD
#    git submodule init && git submodule update --recursive
#    cd external/tsschecker
#    git submodule init && git submodule update --recursive
#    cd ${FR_BASE}
#    curl -sO https://opensource.apple.com/tarballs/cctools/cctools-927.0.2.tar.gz
#    tar xf cctools-927.0.2.tar.gz -C ${FR_BASE}/
#    mv cctools-927.0.2 cctools
#    cd ${FR_BASE}/cctools
#    sed -i 's_#include_//_g' include/mach-o/loader.h
#    sed -i -e 's=<stdint.h>=\n#include <stdint.h>\ntypedef int integer_t;\ntypedef integer_t cpu_type_t;\ntypedef integer_t cpu_subtype_t;\ntypedef integer_t cpu_threadtype_t;\ntypedef int vm_prot_t;=g' include/mach-o/loader.h
#    mkdir -p /tmp/out/include
#    cp -RpP include/* /tmp/out/include
    cd ${FR_BASE}
    echo "Done"
}

function build () {
    echo "Building all deps and futurerestore"
     echo "Building openssl..."
     # openssl
     cd ${FR_BASE}/openssl
     # rm -r *; git fetch origin openssl-3.0; git reset --hard FETCH_HEAD
      ./Configure -C mingw64 --prefix=/tmp/out ${CC_ARGS}
      $MAKE ${CC_ARGS} CFLAGS="${C_ARGS}" LDFLAGS="${LD_ARGS}" install_dev
     rm -r /tmp/out/bin /tmp/out/lib/lib64/{crypto,ssl}.dll* || true
     mkdir /tmp/out/lib || true
     mv /tmp/out/lib64/* /tmp/out/lib || true
    # echo "Building curl..."
    # #curl
    # cd ${FR_BASE}/curl
    # # rm -r *; git fetch origin master; git reset --hard FETCH_HEAD
    # # autoreconf -vi
    # # ./configure -C --prefix=/tmp/out --enable-static --disable-shared --disable-debug --disable-dependency-tracking --with-schannel --without-ssl ${CC_ARGS} CFLAGS="${C_ARGS}" CPPFLAGS="-DCURL_STATICLIB" LDFLAGS="${LD_ARGS}" PKG_CONFIG_PATH="${PKG_CFG}"
    # $MAKE install
    # rm -rf /tmp/out/{bin,share} /tmp/out/lib/libcurl.la
    # echo "Building xpwn..."
    # #xpwn
    # cd ${FR_BASE}/xpwn
    # # rm -r *; git fetch origin master; git reset --hard FETCH_HEAD
    # rm -rf /tmp/out/include/{zip,zipconf}.h || true
    # sed -i 's/#include <fnmatch.h>//g' ipsw-patch/outputstate.c
    # $CMAKE .
    # cp -RpP /mingw64/include/{zip,zipconf}.h /tmp/ || true
    # rm /mingw64/include/{zip,zipconf}.h || true
    # $MAKE ${CC_ARGS} CFLAGS="${C_ARGS}" CXXFLAGS="${CXX_ARGS}" LDFLAGS="${LD_ARGS}" common/fast xpwn/fast
    # cp -RpP /tmp/{zip,zipconf}.h /mingw64/include/
    # cp -RpP includes/* /tmp/out/include/
    # cp -RpP ipsw-patch/libxpwn.a common/libcommon.a /tmp/out/lib
    # echo "Building libzip..."
    # #libzip
    # cd ${FR_BASE}/libzip
    # # rm -r *; git fetch origin master; git reset --hard FETCH_HEAD
    # $CMAKE .
    # sed -i '77,78d' cmake_install.cmake
    # sed -i 's/srandom((/srand((/g' lib/zip_random_unix.c
    # sed -i 's/random()/rand()/g' lib/zip_random_unix.c
    # $MAKE ${CC_ARGS} CFLAGS="${C_ARGS} -D_WIN32=1" LDFLAGS="${LD_ARGS}" zip/fast
    # $MAKE install/strip/fast
    # rm -rf /tmp/out/lib/cmake
    # echo "Building lzfse..."
    # #lzfse
    # cd ${FR_BASE}/lzfse
    # # rm -r *; git fetch origin master; git reset --hard FETCH_HEAD
    # $MAKE ${CC_ARGS} CFLAGS="${C_ARGS}" LDFLAGS="${LD_ARGS}" INSTALL_PREFIX=/tmp/out install
    # rm -rf /tmp/out/bin
    # echo "Building libplist..."
    # #libplist
    # cd ${FR_BASE}/libplist
    # # rm -r *; git fetch origin master; git reset --hard FETCH_HEAD
    # sed -i '45,48d' src/plist.h
    # sed -i '40,43d' src/plist.h
    # ./autogen.sh ${CONF_ARGS} ${CC_ARGS} CFLAGS="${C_ARGS}" CXXFLAGS="${CXX_ARGS}" LDFLAGS="${LD_ARGS}" PKG_CONFIG_PATH="${PKG_CFG}"
    # $MAKE install
    # rm -rf /tmp/out/{bin,share} /tmp/out/lib/libplist*.la
    # echo "Building libimobiledevice-glue..."
    # #libimobiledevice-glue
    # cd ${FR_BASE}/libimobiledevice-glue
    # # rm -r *; git fetch origin master; git reset --hard FETCH_HEAD
    # sed -i '33,36d' src/common.h
    # sed -i '28,31d' src/common.h
    # ./autogen.sh ${CONF_ARGS} ${CC_ARGS} CFLAGS="${C_ARGS}" LDFLAGS="${LD_ARGS}" PKG_CONFIG_PATH="${PKG_CFG}"
    # $MAKE install
    # rm -rf /tmp/out/lib/libimobiledevice-glue*.la
    # echo "Building libusbmuxd..."
    # #libusbmuxd
    # cd ${FR_BASE}/libusbmuxd
    # # rm -r *; git fetch origin master; git reset --hard FETCH_HEAD
    # ./autogen.sh ${CONF_ARGS} ${CC_ARGS} CFLAGS="${C_ARGS}" LDFLAGS="${LD_ARGS}" LIBS="-liphlpapi -lws2_32" PKG_CONFIG_PATH="${PKG_CFG}"
    # $MAKE install
    # rm -rf /tmp/out/{bin,share} /tmp/out/lib/libusbmuxd*.la
    # echo "Building libimobiledevice..."
    # #libimobiledevice
    # cd ${FR_BASE}/libimobiledevice
    # # rm -r *; git fetch origin master; git reset --hard FETCH_HEAD
    # sed -i '45,48d' src/idevice.h
    # sed -i '40,43d' src/idevice.h
    # ./autogen.sh ${CONF_ARGS} ${CC_ARGS} CFLAGS="${C_ARGS}" LDFLAGS="${LD_ARGS}" LIBS="-limobiledevice-glue-1.0 -lole32 -liphlpapi -lws2_32" PKG_CONFIG_PATH="${PKG_CFG}"
    # $MAKE install
    # rm -rf /tmp/out/{bin,share} /tmp/out/lib/libimobiledevice*.la
    # echo "Building libirecovery..."
    # #libirecovery
    # cd ${FR_BASE}/libirecovery
    # # rm -r *; git fetch origin master; git reset --hard FETCH_HEAD
    # sed -i '65,68d' src/libirecovery.c
    # sed -i '60,63d' src/libirecovery.c
    # sed -i'' 's|ret = DeviceIoControl(client->handle, 0x220195, data, length, data, length, (PDWORD) transferred, NULL);|ret = DeviceIoControl(client->handle, 0x2201B6, data, length, data, length, (PDWORD) transferred, NULL);|' src/libirecovery.c
    # sed -i 's/%016" PRIx64 "/%016X/g' src/libirecovery.c
    # ./autogen.sh ${CONF_ARGS} ${CC_ARGS} CFLAGS="${C_ARGS}" LDFLAGS="${LD_ARGS}" LIBS="-lncurses -lreadline -lsetupapi" PKG_CONFIG_PATH="${PKG_CFG}"
    # $MAKE install
    # rm -rf /tmp/out/lib/libirecovery*.la /tmp/out/bin
    # echo "Building libgeneral..."
    # #libgeneral
    # cd ${FR_BASE}/libgeneral
    # rm -r *; git fetch origin e0d98cbeedece5d62e3e9432c3ed37cd87da5338; git reset --hard FETCH_HEAD
    # sed -i'' 's|vasprintf(&_err, err, ap);|_err=(char*)malloc(1024);vsprintf(_err, err, ap);|' libgeneral/exception.cpp
    # ./autogen.sh ${CONF_ARGS} ${CC_ARGS} CFLAGS="${C_ARGS}" CXXFLAGS="${CXX_ARGS}" LDFLAGS="${LD_ARGS}" PKG_CONFIG_PATH="${PKG_CFG}"
    # $MAKE install
    # rm -rf /tmp/out/lib/libgeneral*.la
    # echo "Building libinsn..."
    # #libinsn
    # cd ${FR_BASE}/libinsn
    # # rm -r *; git fetch origin master; git reset --hard FETCH_HEAD
    # # sed -i'' 's|#include <string.h>|#include <string.h>\nvoid* memmem(const void* haystack, size_t haystackLen, const void* needle, size_t needleLen) { if (needleLen == 0 \|\| haystack == needle) { return (void*)haystack; } if (haystack == NULL \|\| needle == NULL) { return NULL; } const unsigned char* haystackStart = (const unsigned char*)haystack; const unsigned char* needleStart = (const unsigned char*)needle; const unsigned char needleEndChr = *(needleStart + needleLen - 1); ++haystackLen; for (; --haystackLen >= needleLen; ++haystackStart) { size_t x = needleLen; const unsigned char* n = needleStart; const unsigned char* h = haystackStart; if (*haystackStart != *needleStart \|\| *(haystackStart + needleLen - 1) != needleEndChr) { continue; } while (--x > 0) { if (*h++ != *n++) { break; } } if (x == 0) { return (void*)haystackStart; } } return NULL; }|' libinsn/vsegment.cpp
    # ./autogen.sh ${CONF_ARGS} ${CC_ARGS} CFLAGS="${C_ARGS}" CXXFLAGS="${CXX_ARGS}" LDFLAGS="${LD_ARGS}" PKG_CONFIG_PATH="${PKG_CFG}"
    # $MAKE install
    # rm -rf /tmp/out/lib/libinsn*.la
    # echo "Building img4tool..."
    # #img4tool
    # cd ${FR_BASE}/img4tool
    # # rm -r *; git fetch origin master; git reset --hard FETCH_HEAD
    # sed -i'' 's|#include <arpa/inet.h>|#include <winsock2.h>\nvoid* memmem(const void* haystack, size_t haystackLen, const void* needle, size_t needleLen) { if (needleLen == 0 \|\| haystack == needle) { return (void*)haystack; } if (haystack == NULL \|\| needle == NULL) { return NULL; } const unsigned char* haystackStart = (const unsigned char*)haystack; const unsigned char* needleStart = (const unsigned char*)needle; const unsigned char needleEndChr = *(needleStart + needleLen - 1); ++haystackLen; for (; --haystackLen >= needleLen; ++haystackStart) { size_t x = needleLen; const unsigned char* n = needleStart; const unsigned char* h = haystackStart; if (*haystackStart != *needleStart \|\| *(haystackStart + needleLen - 1) != needleEndChr) { continue; } while (--x > 0) { if (*h++ != *n++) { break; } } if (x == 0) { return (void*)haystackStart; } } return NULL; }|' img4tool/lzssdec.c
    # sed -i'' 's|#include <arpa/inet.h>|#include <winsock2.h>|' img4tool/img4tool.cpp
    # sed -i 's/arpa\/inet.h/Winsock2.h/g' img4tool/img4tool.cpp img4tool/lzssdec.c
    # ./autogen.sh ${CONF_ARGS} ${CC_ARGS} CFLAGS="${C_ARGS}" CXXFLAGS="${CXX_ARGS}" LDFLAGS="${LD_ARGS}" LIBS="-lws2_32" PKG_CONFIG_PATH="${PKG_CFG}"
    # cd ${FR_BASE}/img4tool/img4tool
    # ln -sf ../include/img4tool/img4tool.hpp img4tool.hpp
    # ln -sf ../include/img4tool/ASN1DERElement.hpp ASN1DERElement.hpp
    # cd ${FR_BASE}/img4tool
    # $MAKE install
    # rm -rf /tmp/out/lib/libimg4tool*.la /tmp/out/bin
    # echo "Building liboffsetfinder64..."
    # #liboffsetfinder64
    # cd ${FR_BASE}/liboffsetfinder64
    # # rm -r *; git fetch origin main; git reset --hard FETCH_HEAD
    # sed -i 's/arpa\/inet.h/Winsock2.h/g' liboffsetfinder64/machopatchfinder64.cpp
    # sed -i '215,231d' liboffsetfinder64/ibootpatchfinder64_base.cpp
    # ./autogen.sh ${CONF_ARGS} ${CC_ARGS} CFLAGS="${C_ARGS}" CXXFLAGS="${CXX_ARGS}" LDFLAGS="${LD_ARGS}" PKG_CONFIG_PATH="${PKG_CFG}"
    # $MAKE install
    # rm -rf /tmp/out/lib/liboffsetfinder64*.la
    # echo "Building libfragmentzip..."
    # #libfragmentzip
    # cd ${FR_BASE}/libfragmentzip
    # # rm -r *; git fetch origin master; git reset --hard FETCH_HEAD
    # sed -i'' 's|fopen(savepath, \"w\")|fopen(savepath, \"wb\")|' libfragmentzip/libfragmentzip.c
    # ./autogen.sh ${CONF_ARGS} ${CC_ARGS} CFLAGS="${C_ARGS}" CPPFLAGS="-DCURL_STATICLIB" LDFLAGS="${LD_ARGS}" PKG_CONFIG_PATH="${PKG_CFG}"
    # $MAKE install
    # rm -rf /tmp/out/lib/libfragmentzip*.la
    # echo "Building libipatcher..."
    # #libipatcher
    # cd ${FR_BASE}/libipatcher
    # rm -r *; git fetch origin main; git reset --hard FETCH_HEAD; git submodule init; git submodule update --recursive
    # ./autogen.sh ${CONF_ARGS} ${CC_ARGS} CFLAGS="${C_ARGS}" CXXFLAGS="${CXX_ARGS}" CPPFLAGS="-DCURL_STATICLIB" LDFLAGS="${LD_ARGS}" LIBS="-lcurl -lpng16" PKG_CONFIG_PATH="${PKG_CFG}"
    # $MAKE install
    # rm -rf /tmp/out/lib/libipatcher*.la
    echo "Building futurerestore!"
    #futurerestore
    cd ${FR_BASE}/futurerestore
    rm -r *; git fetch origin test; git reset --hard FETCH_HEAD; git submodule init; git submodule update --recursive; cp -RpP /tmp/{Makefile.am,futurerestore.cpp1} futurerestore/;
    # ; cp -RpP /tmp/{Makefile.am,futurerestore.cpp} futurerestore/; cp -RpP /tmp/{common,recovery}.c external/idevicerestore/src
    sed -i'' 's|fopen(dstPath, \"w\")|fopen(dstPath, \"wb\")|' external/tsschecker/tsschecker/download.c
    sed -i'' 's|fopen(fname, \"w\")|fopen(fname, \"wb\")|' external/tsschecker/tsschecker/tsschecker.c
    sed -i 's/PTHREAD_CFLAGS="-pthread"/PTHREAD_CFLAGS="-lwinpthread"/g' external/idevicerestore/m4/ax_pthread.m4
    sed -i 's/ax_pthread_try -pthread/ax_pthread_try -lwinpthread/g' external/idevicerestore/m4/ax_pthread.m4
    sed -i 's/ax_pthread_flags="-mt -pthread pthread $ax_pthread_flags"/ax_pthread_flags="-mt -lwinpthread pthread $ax_pthread_flags"/g' external/idevicerestore/m4/ax_pthread.m4
    sed -i 's/ax_pthread_flags="-pthread -pthreads $ax_pthread_flags"/ax_pthread_flags="-lwinpthread $ax_pthread_flags"/g' external/idevicerestore/m4/ax_pthread.m4
    sed -i 's/ax_pthread_flags="pthreads none -Kthread -pthread -pthreads -mthreads pthread --thread-safe -mt pthread-config"/ax_pthread_flags="pthreads none -Kthread -lwinpthread -mthreads pthread --thread-safe -mt pthread-config"/g' external/idevicerestore/m4/ax_pthread.m4
    sed -i 's/tsschecker_LDFLAGS = -lpthread/tsschecker_LDFLAGS = -lwinpthread/g' external/tsschecker/tsschecker/Makefile.am
    sed -i 's/device %016" PRIx64 "/device %016llX/g' external/idevicerestore/src/idevicerestore.c
    sed -i 's/0x%" PRIx64 "/0x%X/g' external/idevicerestore/src/restore.c
    sed -i 's/%" PRIu64 "/%llu/g' external/idevicerestore/src/fdr.c external/idevicerestore/src/common.c external/idevicerestore/src/idevicerestore.c external/idevicerestore/src/ipsw.c external/idevicerestore/src/restore.c external/idevicerestore/src/tss.c
    sed -i 's/%"PRIu64/%llu"/g' external/idevicerestore/src/ipsw.c external/idevicerestore/src/tss.c
    sed -i 's/now\.\.\.\\n/now\.\.\.\\n\\n/g' external/idevicerestore/src/restore.c
    ./autogen.sh ${CONF_ARGS} --enable-static ${CC_ARGS} CFLAGS="${C_ARGS} -DIDEVICERESTORE_NOMAIN=1 -DTSSCHECKER_NOMAIN=1 -DWIN32=1 -D_WIN32=1" CXXFLAGS="${CXX_ARGS} -DIDEVICERESTORE_NOMAIN=1 -DTSSCHECKER_NOMAIN=1 -DWIN32=1 -D_WIN32=1" LDFLAGS="${LD_ARGS}" LIBS="-lwinpthread -lgeneral -limg4tool -llzfse -lxpwn -lzip -lpng16 -lcommon -lipatcher -loffsetfinder64 -linsn -lplist-2.0 -limobiledevice-1.0 -limobiledevice-glue-1.0 -lusbmuxd-2.0 -lbz2 -llzma -lbcrypt -lmsvcrt -lucrt -lsetupapi -lcrypt32 -lwldap32 -lole32 -liphlpapi -lws2_32" libplist_LIBS="" libfragmentzip_LIBS="" libgeneral_LIBS="" libimg4tool_LIBS="" libimobiledevice_LIBS="" libipatcher_LIBS="" libirecovery_LIBS="" libzip_LIBS="" PKG_CONFIG_PATH="${PKG_CFG}"
    $MAKE
    $MAKE install
    echo "Done!"
}

function futurerestoreBuild () {
    echo "Welcome to futurerestore static builder script for linux made by @Cryptiiiic !"
    echo "If prompted, enter your password"
    echo -n ""
    echo "Compiling..."
    echo -n "Step 1: "
    setupDIR
    echo -n "Step 2: "
     getAPTDeps
    echo -n "Step 3: "
     cloneRepos
    echo -n "Step 4: "
    build
    echo -e "End\n"
    cd $DIR
    file /tmp/out/bin/futurerestore || true
    /tmp/out/bin/futurerestore || true
    ldd /tmp/out/bin/futurerestore || true
    echo ""
    export script_timer_stop=$(date +%s)
    export script_timer_time=$((script_timer_stop-script_timer_start))
    export script_timer_minutes=$(((script_timer_time % (60*60)) / 60))
    export script_timer_seconds=$(((script_timer_time % (60*60)) % 60))
    echo "Build completed in ""$script_timer_minutes"" minutes and ""$script_timer_seconds"" seconds!"
    unset FR_BASE
    unset CC_ARGS
    unset CONF_ARGS
    unset ALT_CONF_ARGS
    unset LD_ARGS
    unset JNUM
    unset LNUM
    unset script_timer_start
    unset script_timer_stop
    unset script_timer_time
    unset script_timer_minutes
    unset script_timer_seconds
    unset DIR
}

futurerestoreBuild
