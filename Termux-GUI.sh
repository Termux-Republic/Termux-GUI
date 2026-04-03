#!/data/data/com.termux/files/usr/bin/bash

SCRIPTS_DIR="$(pwd)"

banner() {
    echo "================================"
    echo "     Termux GUI Installer"
    echo "================================"
    echo ""
}

make_start_script() {
    local name="$1"
    local start_cmd="$2"
    local out="$SCRIPTS_DIR/${name}-Start.sh"

    cat > "$out" << EOF
#!/data/data/com.termux/files/usr/bin/bash

pkill -f termux-x11 2>/dev/null
pkill -f pulseaudio 2>/dev/null
pkill -f Xwayland 2>/dev/null
sleep 1

pulseaudio --start >/dev/null 2>&1
termux-x11 :0 >/dev/null 2>&1 & disown 2>/dev/null; true
sleep 1

rm -f /tmp/.X0-lock /tmp/.X11-unix/X0 2>/dev/null
export DISPLAY=:0

$start_cmd
EOF

    chmod +x "$out"
}

install_kde() {
    echo "Installing KDE Plasma (this will take a while)..."
    pkg install -y x11-repo
    pkg install -y kde-plasma
    make_start_script "KDE-Plasma" "dbus-launch --exit-with-session startplasma-x11 >/dev/null 2>&1"
}

install_gnome() {
    echo "NOTE: GNOME requires manual setup after install."
    echo "See: https://wiki.termux.com/wiki/Graphical_Environment"
    echo ""
    echo "Installing GNOME base packages..."
    pkg install -y x11-repo
    pkg install -y gnome
    make_start_script "GNOME" "dbus-launch --exit-with-session gnome-session >/dev/null 2>&1"
}

install_mate() {
    echo "Installing MATE..."
    pkg install -y x11-repo
    pkg install -y mate-desktop mate-terminal mate-file-manager mate-panel mate-session-manager
    make_start_script "MATE" "dbus-launch --exit-with-session mate-session >/dev/null 2>&1"
}

install_lxqt() {
    echo "Installing LXQt..."
    pkg install -y x11-repo
    pkg install -y lxqt
    make_start_script "LXQt" "dbus-launch --exit-with-session startlxqt >/dev/null 2>&1"
}

install_lxde() {
    echo "Installing LXDE..."
    pkg install -y x11-repo
    pkg install -y lxde
    make_start_script "LXDE" "dbus-launch --exit-with-session startlxde >/dev/null 2>&1"
}

install_xfce4() {
    echo "Installing XFCE4 + goodies..."
    pkg install -y x11-repo
    pkg install -y xfce4 xfce4-goodies
    make_start_script "XFCE4" "dbus-launch --exit-with-session xfce4-session >/dev/null 2>&1"
}

install_i3() {
    echo "Installing i3WM..."
    pkg install -y x11-repo
    pkg install -y i3 i3status dmenu rxvt-unicode
    make_start_script "i3WM" "dbus-launch --exit-with-session i3 >/dev/null 2>&1"
}

install_fluxbox() {
    echo "Installing Fluxbox..."
    pkg install -y x11-repo
    pkg install -y fluxbox xterm
    make_start_script "Fluxbox" "dbus-launch --exit-with-session fluxbox >/dev/null 2>&1"
}

install_openbox() {
    echo "Installing Openbox..."
    pkg install -y x11-repo
    pkg install -y openbox obconf xterm tint2
    make_start_script "Openbox" "dbus-launch --exit-with-session openbox-session >/dev/null 2>&1"
}

install_xfwm4() {
    echo "Installing XFWM4..."
    pkg install -y x11-repo
    pkg install -y xfwm4 xterm
    make_start_script "XFWM4" "dbus-launch --exit-with-session xfwm4 >/dev/null 2>&1"
}

banner

echo "--- Heavy DEs ---"
echo "  1) KDE Plasma"
echo "  2) GNOME (requires manual setup)"
echo ""
echo "--- Normal DEs ---"
echo "  3) MATE"
echo "  4) LXQt"
echo "  5) LXDE"
echo "  6) XFCE4"
echo ""
echo "--- Window Managers ---"
echo "  7) i3WM"
echo "  8) Fluxbox"
echo "  9) Openbox"
echo " 10) XFWM4"
echo ""
read -p "Pick a number: " choice

case $choice in
    1)  install_kde ;;
    2)  install_gnome ;;
    3)  install_mate ;;
    4)  install_lxqt ;;
    5)  install_lxde ;;
    6)  install_xfce4 ;;
    7)  install_i3 ;;
    8)  install_fluxbox ;;
    9)  install_openbox ;;
    10) install_xfwm4 ;;
    *)  echo "Invalid choice." ;;
esac
