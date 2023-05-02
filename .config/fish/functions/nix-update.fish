function nix-update
  nix-channel --update;
  and home-manager switch; 
  and nix-collect-garbage --delete-older-than 7d; 
  and nix-store --optimise
end

