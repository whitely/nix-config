#!/usr/bin/env bash

mkdir -p ~/.config/xdg-desktop-portal/

cat > ~/.config/xdg-desktop-portal/portals.conf << 'EOF'
[preferred]
default=kde
EOF

# Restart the main portal service
systemctl --user restart plasma-xdg-desktop-portal-kde.service
systemctl --user restart xdg-desktop-portal.service

# Wait for it to settle
sleep 3

# Check status
systemctl --user status xdg-desktop-portal.service plasma-xdg-desktop-portal-kde.service

# Now test if ScreenCast is available
busctl --user introspect org.freedesktop.portal.Desktop /org/freedesktop/portal/desktop org.freedesktop.portal.ScreenCast
