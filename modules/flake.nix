# flake-parts setup: enables flake.modules.<class>.<name>, which every feature file fills.
{ inputs, ... }:
{
  imports = [ inputs.flake-parts.flakeModules.modules ];
  systems = [ "x86_64-linux" ];
}
