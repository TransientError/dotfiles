function nix-info
  nix-env -qa --json $argv | \
  jq 'to_entries[] | {key: .key, name: .value.meta.name, homepage:.value.meta.homepage, license: .value.meta.license.fullName, platforms: .value.meta.platforms}'
end

