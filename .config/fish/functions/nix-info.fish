function nix-info
  nix-env -qa --json $argv | jq 'to_entries[] | {key: .key, name: .value.meta.name, homepage:.value.meta.homepage}'
end

