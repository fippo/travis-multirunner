#!/usr/bin/env bash
BASE_FIREFOX=ftp.mozilla.org/pub/mozilla.org/firefox
BASE_FIREFOX_NIGHTLY=$BASE_FIREFOX/nightly/latest-trunk
BASE_FIREFOX_RELEASE=$BASE_FIREFOX/releases
BASE_FIREFOX_STABLE=$BASE_FIREFOX_RELEASE/latest/linux-x86_64/en-US
BASE_FIREFOX_BETA=$BASE_FIREFOX_RELEASE/latest-beta/linux-x86_64/en-US
BASE_FIREFOX_ESR=$BASE_FIREFOX_RELEASE/latest-esr/linux-x86_64/en-US

extractFirefoxVersion() {
  echo $1 | sed -r "s/^.*firefox-([0-9\.ba]+)\..*tar.bz2$/\1/"
}

getChromeVersion() {
  case $1 in
    unstable)
      VERSION=`curl -s https://omahaproxy.appspot.com/all | grep ^linux\,dev | cut -d',' -f3`
      ;;
    beta|stable)
      VERSION=`curl -s https://omahaproxy.appspot.com/all | grep ^linux\,$1 | cut -d',' -f3`
      ;;
    *)
      VERSION=$1
      ;;
  esac
  
  # extract commit from chrome version
  COMMIT=`curl -s http://omahaproxy.appspot.com/revision.json?version=$VERSION | cut -d'"' -f4`
  # go to https://commondatastorage.googleapis.com/chromium-browser-continuous/index.html?prefix=Linux_x64/$COMMIT/ and grab zip

  echo "chrome|$1|$VERSION|https://www.googleapis.com/download/storage/v1/b/chromium-browser-continuous/o/Linux_x64%2F$COMMIT%2Fchrome-linux.zip?alt=media"
}

getFirefoxVersion() {
  case $1 in
    stable)
      TARGET=http://$BASE_FIREFOX_STABLE/`curl -s --list-only ftp://$BASE_FIREFOX_STABLE/`
      ;;
    beta)
      TARGET=http://$BASE_FIREFOX_BETA/`curl -s --list-only ftp://$BASE_FIREFOX_BETA/`
      ;;
    unstable)
      TARGET=http://$BASE_FIREFOX_NIGHTLY/`curl -s --list-only ftp://$BASE_FIREFOX_NIGHTLY/ | grep -e en-US\.linux-x86_64\.tar\.bz2`
      ;;
    esr)
      TARGET=http://$BASE_FIREFOX_ESR/`curl -s --list-only ftp://$BASE_FIREFOX_ESR/`
      ;;
  esac

  echo "firefox|$1|$(extractFirefoxVersion $TARGET)|$TARGET"
}

case $1 in
  chrome)
    getChromeVersion $2
    ;;
  
  firefox)
    getFirefoxVersion $2
    ;;
esac
