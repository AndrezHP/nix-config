{
  pkgs,
  lib,
  inputs,
  ...
}:
let
  nexusParams = builtins.fromJSON (builtins.getEnv "NEXUS_CONFIG");
  mail = nexusParams.mail;
  pw = nexusParams.pw;
  token = nexusParams.token;
  base64pw = lib.strings.removeSuffix "\n" (
    builtins.readFile (
      pkgs.stdenv.mkDerivation {
        name = "";
        src = null;
        buildInputs = [
          pkgs.openssl
        ];
        buildCommand = ''
          echo ${pw} | openssl enc -base64 > $out
        '';
      }
    )
  );
in
{
  config = {
    imports = [
      inputs.sops-nix.homeManagerModules.sops
    ];

    home.file.".netrc1".source = builtins.toFile ".netrc" ''
      machine nexus.secata.com login ${mail} password ${pw}
    '';

    home.file.".npmrc1".source = builtins.toFile ".npmrc" ''
      //nexus.secata.com/repository/npm/:username=${mail}
      //nexus.secata.com/repository/npm/:email=${mail}
      //nexus.secata.com/repository/npm/:_password=${base64pw}
      //nexus.secata.com/repository/npm/:always-auth=true
      @secata:registry=https://nexus.secata.com/repository/npm/
      @partisia:registry=https://nexus.secata.com/repository/npm/
      //nexus.privacyblockchain.io/repository/npm/:username=${mail}
      //nexus.privacyblockchain.io/repository/npm/:email=${mail}
      //nexus.privacyblockchain.io/repository/npm/:_password==${base64pw}
      //nexus.privacyblockchain.io/repository/npm/:always-auth=true
      @privacyblockchain:registry=https://nexus.privacyblockchain.io/repository/npm/
    '';

    home.file.".m2/settings.xml1".source = builtins.toFile ".m2-settings.xml" ''
      <settings>
        <servers>
          <server>
            <id>secata</id>
            <username>${mail}</username>
            <password>${pw}</password>
          </server>
          <server>
            <id>privacyblockchain</id>
            <username>${mail}</username>
            <password>${pw}</password>
          </server>
          <server>
            <id>gitlab-partisiablockchain</id>
            <configuration>
              <httpHeaders>
                <property>
                  <name>Private-Token</name>
                  <value>${token}</value>
                </property>
              </httpHeaders>
            </configuration>
          </server>
          <server>
            <id>gitlab-privacyblockchain</id>
            <configuration>
              <httpHeaders>
                <property>
                  <name>Private-Token</name>
                  <value>${token}</value>
                </property>
              </httpHeaders>
            </configuration>
          </server>
          <server>
            <id>gitlab-secata</id>
            <configuration>
              <httpHeaders>
                <property>
                  <name>Private-Token</name>
                  <value>${token}</value>
                </property>
              </httpHeaders>
            </configuration>
          </server>
        </servers>
      </settings>
    '';
    assertions = [
      {
        assertion =
          (builtins.stringLength mail) >= 1
          && (builtins.stringLength pw) >= 1
          && (builtins.stringLength token) >= 1;
        message = ''
          You must create a JSON file at ~/.nexus
          And fill out the entries:
          {
          "mail": "YOUR MAIL",
          "pw": "PASSWORD",
          "token": "GITLAB_PRIVATE_TOKEN"
          }
          to be able to create configurations for Nexus access
        '';
      }
    ];
  };
}
