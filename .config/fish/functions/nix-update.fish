function nix-update
  nix-channel --update;
  home-manager switch;
  nix-collect-garbage --delete-older-than 7d;
  nix optimise-store
end

