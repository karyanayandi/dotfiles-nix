{
  inputs,
  outputs,
  ...
}: let
  sharedModules =
    [
      inputs.home-manager.nixosModules.home-manager
      {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          extraSpecialArgs = {inherit inputs outputs;};
          users.karyana = ../home/karyana;
        };
      }
    ]
    ++ (builtins.attrValues outputs.nixosModules);
in {
  computer = outputs.lib.nixosSystem {
    modules =
      [
        ./computer
        {networking.hostName = "computer";}
      ]
      ++ sharedModules;

    specialArgs = {inherit inputs;};
    system = "x86_64-linux";
  };
}
