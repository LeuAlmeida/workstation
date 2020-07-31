echo -n "${YELLOW}${LIGHTRED}No scripts available to Debian distro. Do you want to run Ubuntu script (y/n)?${NOCOLOR}"
read answer

if [ "$answer" != "${answer#[Yy]}" ] ;then
    sh ./ubuntu.sh
fi