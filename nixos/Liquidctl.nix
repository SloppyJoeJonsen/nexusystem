# SDDM is a display manager for X11 and Wayland
# This is currently unused by default, to allow for more consistent theming and wider animated lock screen support.
{ pkgs, inputs, config, lib, ... }:
{
  programs.coolercontrol = {
        enable = true;
    };
}
