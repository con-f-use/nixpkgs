{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "webwormhole";
  version = "unstable-2021-03-28";

  src = fetchFromGitHub {
    owner = "saljam";
    repo = pname;
    rev = "1c8919c7052042858e8ccf484f058be480affdd3";
    sha256 = "sha256-tK5GMS48W7kz0sp4jCH6Dtvbzqk9u+mPrxgpbv2eZXM=";
  };

  vendorSha256 = "sha256-yK04gjDO6JSDcJULcbJBBuPBhx792JNn+B227lDUrWk=";

  meta = with lib; {
    homepage = "https://${pname}.io/";
    maintainers = with maintainers; [ confus ];
    license = licenses.bsd3;
    description = "Creates ephemeral pipes between computers to send files
or other data";
   };
}
