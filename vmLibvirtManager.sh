#!/bin/bash


# Ejemplos de comando
#virt-install --name kaliii --ram 4096 -vcpus=1 --disk path=/mnt/test.qcow2,size=14 -c /mnt/kali-linux-2025.3-installer-amd64.iso --os-variant ubuntu23.10 --graphics spice
# sudo  virt-install --name kaliii --ram 4096 -vcpus=1 --disk path=/mnt/test.qcow2,size=14 -c /mnt/kali-linux-2025.3-installer-amd64.iso --os-variant ubuntu23.10 --graphics spice 



if [[ $(id -u) -ne 0 ]]; then
	echo "Debe ejecutarse con privilegios root"
	exit 1
fi 

# Verificar que el servicio libvirt este activado

if [[ $(systemctl status libvirtd | grep "running") ]]; then
	echo "El servicio esta activo "
else 
	echo "No esta activo el servicio"
fi


# Variables que almacenan la ruta que se utilizaran en la maquina virtual
disk=""
ISO=""


diskF(){
	select option in "Crear disco" "Usar disco existente"; do
		case $REPLY in
			1) createDisk && return ;;
			2) existDisk && return ;;
			*) echo "Opcion no encontrada" ;;
		esac
	done
}

existDisk(){
        read -p "Ingresa la ruta al disco a usar: " diskExist
        if [[ -e "$diskExist" ]]; then
                disk="$diskExist"
                qemu-img info $disk
        else
                echo "No existe la ruta..."
		exit 1
        fi
}

createDisk(){
        echo "Creacion de disco "
        read -p "Nombre del disco: " nameDisk
        read -p "Formato del disco (1) raw  (2)qcow2: " formatDiskopc
        if [[ "$formatDiskopc" -eq 1 ]]; then
                formatDisk="raw"
        else
                formatDisk="qcow2"
        fi


        read -p "Tamanio del disco ejem:(10K, 10M, 10G) : " sizeDisk

        read -p "Ingrese la ruta donde se almacenara el disco: " pathDisk
        if [[ ! -d "$pathDisk" ]]; then
                echo "El directorio no existe"
        fi

        qemu-img create -f "$formatDisk" "$pathDisk/$nameDisk.$formatDisk" "$sizeDisk" 

        if [[ $? -ne 0 ]]; then
                echo "Algo salio mal..."
                echo "Eliminar archivos en \"$pathDisk\" si es necesario"
                exit 1
        fi


        echo "Resumen del disco"
        disk="$pathDisk/$nameDisk"
        qemu-img info "$pathDisk/$nameDisk"

}


isoCheck(){
	read -p  "Ingrese ruta del ISO: " pathISO
	if [[ ! -e "$pathISO" ]]; then
		echo "Archivo no encontrado..."
		exit 1
	else
		ISO="$pathISO"
	fi

}



# implementar funcion para -os-variant
# implementar funcion para graphics configuration 
# Probarlo


read -p "Nombre de la maquina: " nameMachine
read -p "Ram de la maquina: " ramMachine
read -p "Cpu's de la maquina " cpuMachine
diskF
isoCheck
read -p 

