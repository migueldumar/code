#powershell_jenkins_sql_execute.ps1

<#
caso não seja fixo o servidor, criar uma variavel e solicitar que o cliente digite o nome dos servidores separados por ","

$ServidorSQL = $ENV:ServidorSQL
$ServidorSQL = $ServidorSQL -split(',')

$homolog= @(

$ServidorSQL

)

#>


<#
caso o nomero de servidores seja elevado, criar uma variavel e solicitar que o cliente importe uma arquivo com os
servidores separados por ","

$ServidorSQL = gc "arquivo"
$ServidorSQL = $ServidorSQL -split(',')

$homolog= @(

$ServidorSQL

)

#>


<#
variavél com o caminho de onde será feito o backup e para onde será feita a copia
$origem = "caminho"
#>

$homolog= @(
    'servidor01'
    'servidor02'
)
#variavel com o nome da database
$db = "agenciabnb"
#variavel com a tabela que será consultada
$var= "$db..TABELA"


#exibição do texto do script que foi realizado o download do RAM
write-host "script do RAM"
get-content $ENV:WORKSPACE\SCRIPT_RAM.sql

#coleta do texto do script que foi realizado o download do RAM
$text = get-content $ENV:WORKSPACE\SCRIPT_RAM.sql

#Substituir o texto com o nome da tabela pelo que esta na variavel $var que foi declarada anteriormente
# no caminho do $ENV:WORKSPACE e criar o scirpt "script.sql" para a execução
$text -replace 'TABELA',"$var" |Set-Content $ENV:WORKSPACE\script.sql


#foreach para execução do script nos servidores sql 
foreach ($s in $homolog){

#exibir o nome do servidor e realizar um select antes da execução
write-host "Servidor "$s
write-host " "
write-host "consulta antes da execução"

#select antes da execução e alocar em uma variavel
$antes = invoke-sqlcmd -Query "select * from $var"  -serverinstance "$s" 

#exibir o resultado do select no formato de tabela
write-host ($antes | Format-Table | Out-String) 

#iniciar a execução
write-host "inicio da execução"


write-host "script"
#executar o script que foi cirado na linha 55 com os parametros de instancia e database

invoke-sqlcmd -inputfile "$ENV:WORKSPACE\script.sql" -serverinstance "$s" -database "$db"

# limitado e exibindo no log o final da execução
write-host " final da execução"

#wait 3 seg para proxima execução
sleep 3

#select depois da execução e alocar em uma variavel
$depois= invoke-sqlcmd -Query "select * from $db..TABELA"  -serverinstance "$s" 

write-host "consulta depois execução"
#exibir o resultado do select no formato de tabela
write-host ($depois| Format-Table | Out-String)

}
