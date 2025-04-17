#!/usr/bin/perl

$rep = "dat2txt.git";

$repoalt = "git\@gitlab:$rep";
print "REPOALT: $repoalt\n";



print "REPONEU: $reponeu\n";

print "REPONETZ: $reponetz\n";

`git add umzug.pl`;
wait;

`git commit -a -m "Umzug von gitlab auf gitlab.schleibinger.com" `;
wait;
`git push`;
wait;
`git tag`;
wait;
`git branch -a`;
wait;
# `git remote rm $repoalt`;
`git remote rm origin`;
wait;
`git remote add origin $reponeu`;
wait;
`git push origin --all`;
wait;
`git push --tags`;

print "fertig lokal \n";



`git remote add netz2 $reponetz`;

wait;
`git push netz2 `;

print "fertig remote\n";
