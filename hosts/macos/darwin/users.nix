# ./darwin/users.nix
{
  users.users = {
    mb = {
      openssh.authorizedKeys.keys = [ 
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILBd6dQR3TgETR4fZWLle216cgEnbpIjrT8CixXkhwPQ rizzo2025@rizzo2025_mb_2025-10-11i"
      ];
    };
  };
}
