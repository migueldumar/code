#powershell_Jenkins_entrada_booleana_ativo_RAM
#BACKUP APLICACAO
#Cria um diretório no repositório do Jenkins para realização do backup da aplicação
#Caso nao exista, ele ira criar a pasta no repositório de backup com o nome do servidor junto ao numero da mudança
<#
$env:backup variavél com o caminho do backup, configurada no proprio jenkins
$ENV:Sistema variavel coletada no parametro de string do jenkins
$env:Mudanca variavel coletada no parametro de string do jenkins
$ENV:BUILD_ID variavel do jenkins referente ao numero da execução do job
#>

#criação da pasta para backup da aplicação
New-Item $env:backup\$ENV:Sistema\$env:Mudanca\$ENV:BUILD_ID\ -Type Directory

#variavel de negocio recebendo valor $null para iniciar a variavel
$modulo =  $null
$mod =  $null
#Exibir o caminho do workspace onde foi ralizada o download do RAM.
write-host $ENV:WORKSPACE\$Env:Pacote

#$Env:Var01 #variavel de valor booleano
#$Env:Var02 #variavel de valor booleano
#$Env:Var03 #variavel de valor booleano

$Var01 = $Env:Var01 #incremento com a variavel de valor booleano
if ($Var01 -eq "True"){ #condição  incremento de variavel para foreach caso o check box booleano sejá preenchido

write-host "Var01"
$modulo += "Var01 " # incremento de variavel para foreach caso o check box booleano sejá preenchido

}

$Var02 = $Env:Var02 #incremento com a variavel de valor booleano
if ($Var02 -eq "True"){#condição  incremento de variavel para foreach caso o check box booleano sejá preenchido

write-host "Var02"
$modulo += "Var02 "# incremento de variavel para foreach caso o check box booleano sejá preenchido

}

$Var03 = $Env:Var03 #incremento com a variavel de valor booleano
if ($Var03 -eq "True"){#condição  incremento de variavel para foreach caso o check box booleano sejá preenchido

write-host "Var03"
$modulo += " Var03 " # incremento de variavel para foreach caso o check box booleano sejá preenchido

}

#exibição do nome do modulo 
write-host "############ modulo selecionado############### "
write-host $modulo
write-host "############################################## "

write-host " "
<#
limpando a variavel
quebrando a varivavel no pontos onde tem espaço " -split " " " e removendo as linhas em branco where {$_.trim() -ne ''}
#>
$modulo = $modulo -split " " | where {$_.trim() -ne ''} 
   
foreach ($mod in $modulo){ #condição de foreach com a variavel alimentada com o check box booleano
$mod # exibição um por um da condição da alimentação da variavel do foreach
sleep 3

#alimentação do vetor com as variaveis de onde será copiado os arquivos do RAM


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

#foreach para copia para o servidor e realização do backup.
foreach ($s in $homolog){

#exibir o nome do servidor que será copiado
write-host "Servidor "$s
write-host " "
#exibir caminho do modulo
write-host "\\$s\$caminho\$mod"
write-host " "
write-host " Backup "   
#backup
# cria a pasta no servidor de backup com o nome do servidor e o modulo 
New-Item $env:backup\$ENV:Sistema\$env:Mudanca\$ENV:BUILD_ID\$s-$mod -Type Directory
#copia a o modulo do servidor para a pasta criada no passo anterior
Copy-Item -Path \\$s\$caminho\$mod -Destination $env:backup\$ENV:Sistema\$env:Mudanca\$ENV:BUILD_ID\$s-$mod -Recurse -Force
write-host " "
write-host " Copia "
#alteração
Copy -Path $ENV:WORKSPACE\$mod\*.exe -Destination \\$s\$caminho\$mod\temp1 -force
}

}


