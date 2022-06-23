function Get-PgVersion {
    param (
        [Parameter(Mandatory=$false)]
        [string]$pgHost=$env:PGHOST,
        [Parameter(Mandatory=$false)]
        [string]$pgPort=$env:PGPORT,
        [Parameter(Mandatory=$false)]
        [string]$pgDatabase=$env:PGDATABASE,
        [Parameter(Mandatory=$false)]
        [string]$pgUser=$env:PGUSER
    )

    return psql --dbname="postgresql://${pguser}@${pgHost}:${pgPort}/${pgDatabase}" --csv --command="select pg_read_file('PG_VERSION') as pgversion" `
    | ConvertFrom-Csv
}

function Get-PgClusterName {
    param (
        [Parameter(Mandatory=$false)]
        [string]$pgHost=$env:PGHOST,
        [Parameter(Mandatory=$false)]
        [string]$pgPort=$env:PGPORT,
        [Parameter(Mandatory=$false)]
        [string]$pgDatabase=$env:PGDATABASE,
        [Parameter(Mandatory=$false)]
        [string]$pgUser=$env:PGUSER
    )

    return psql --dbname="postgresql://${pguser}@${pgHost}:${pgPort}/${pgDatabase}" --csv --command="select setting from pg_settings where name='cluster_name'" `
    | ConvertFrom-Csv
}