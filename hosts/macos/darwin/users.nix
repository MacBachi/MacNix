# Benutzer-Definition (Werte kommen via specialArgs aus flake.nix:hosts)
{ user, uid, ... }:
{
  users.users.${user} = {
    name = user;
    home = "/Users/${user}";
    inherit uid;
  };
}
