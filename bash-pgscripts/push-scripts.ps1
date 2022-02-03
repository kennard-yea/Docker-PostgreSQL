function Get-DockerContainers {
    param (
    )
    docker container ls -a --no-trunc --format "{{json .Names}},{{json .ID}},{{json .Image}},{{json .Networks}},{{json .Mounts}},{{json .CreatedAt}}" | ConvertFrom-CSV -Header "Name","ID","Image","Network","Mounts","Created"
}

foreach ($cpCandidate in (Get-DockerContainers | Where-Object -Property Image -Like *bash-pgscripts*).Name) {
    docker cp bash-functions.bash ${cpCandidate}:/var/lib/postgresql/lib/
    docker cp postgres-functions.bash ${cpCandidate}:/var/lib/postgresql/lib/
    docker cp pg-basebackup ${cpCandidate}:/var/lib/postgresql/bin/
}
