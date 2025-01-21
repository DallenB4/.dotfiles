{ inputs, config, pkgs, ... }:

{
  hardware.uinput.enable = true;
  services.kanata = {
    enable = true;
    keyboards.default.config = ''
      (defsrc
        caps
      )
      (defalias
        escctrl (tap-hold-press 200 200 esc lctrl)
      )
      (deflayer base
        @escctrl
      )
    '';
    keyboards.default.extraDefCfg = ''
      process-unmapped-keys yes
    '';
  };
}
