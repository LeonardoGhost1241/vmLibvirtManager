# Gestor de libvirt

## Libvirt 
    - Es una capa de administracion y abstraccion que permite controlar tecnologias de virtualizacion como: 
    - KVM/QEMU (la combinacion mas comun en linux)
    - Xen
    - LXC (Contenedores ligeros)
    - VMware ESXi (limitado)
    - Hyper-V (limitado)
    - En linux, lo mas comun es usarlo con KVM/QEMU para maquinas virtuales completas

## Libvirt proporciona:
    * Una API unificada
    * El comando virsh (CLI)
    * La interfaz gráfica virt-manager
    * Gestión de redes virtuales, almacenamiento, snapshots, dispositivos, etc.
    
## Arquitectura  de libvirt (https://libvirt-org.translate.goog/api.html?_x_tr_sl=en&_x_tr_tl=es&_x_tr_hl=es&_x_tr_pto=tc)
    1. libvirtd / virtqemud : Demonio que administra hipervisores. En sistemas modernos se divide en demonios por hipervisor (virtqemud, virtlxc, etc).
    2. libvirt API  : Biblioteca que exponen herramientas como virsh o virt-manager.
    3. Hypervisor backend  : Usualmente QEMU/KVM

( https://fp.josedomingo.org/hlc2122/u01/introduccion.html )

### Archivos y rutas importantes
#### Maquinas virtuales (XML):
    * /etc/libvirt/qemu/ → Definiciones de las VMs persistentes
    * /var/run/libvirt/qemu/ → Estados temporales de ejecución

#### Redes virtuales:
    * /etc/libvirt/qemu/networks/ → Definición de redes NAT, bridges, host-only

#### Almacenamiento: 
    * /var/lib/libvirt/images/  O los pools que definas (LVM, ZFS, directorios, discos completos)


### Herramientas principales 
    * virsh (CLI): Este es el comando principal el cual puede : Iniciar, apagar, crear, modificar, snapshot, redes, storage, etc
    * virt-manager (GUI): Una interfaz gráfica completa. Muy útil
    * virt-install: Permite crear VMs desde terminal con una sola línea



# Instalacion de libvirt 




# Creacion de maquina virtual (3 metodos)

## Metodo 1. Crear una maquina usando el gestor grafico
    1. Para hacerlo ejecutamos el siguiente comando:
    ```
        sudo virt-manager
    ```
    2. Crear nueva VM
    3. Seleccionar ISO
    4. Elegir CPU/RAM
    5. Seleccionar almacenamiento (qcow2 recomendado)
    6. Finalizar

## Metodo 2. Crear una VM desde la terminal (virt-install)
```
sudo virt-install \
  --name ubuntu-test \
  --ram 4096 \
  --vcpus 2 \
  --disk path=/var/lib/libvirt/images/ubuntu-test.qcow2,size=20 \
  --os-variant ubuntu22.04 \
  --cdrom /isos/ubuntu-22.04.iso \
  --network network=default \
  --graphics spice

```

Para ver las variantes soportadas por libvirt, usamos:
```
    virt-install --osinfo list
```

## Metodo 3. Crear VM con virsh + XML
    1. Creacion de archivo XML
```
    <domain type='kvm'>
      <name>debian10</name>
      <memory unit='MiB'>2048</memory>
      <vcpu>2</vcpu>
      <os>
        <type arch='x86_64'>hvm</type>
      </os>
      <devices>
        <disk type='file' device='disk'>
          <source file='/var/lib/libvirt/images/debian10.qcow2'/>
          <driver name='qemu' type='qcow2'/>
        </disk>
        <interface type='network'>
          <source network='default'/>
        </interface>
        <graphics type='spice'/>
      </devices>
    </domain>
```
    2. Definir la VM
    ```
        virsh define debian10.xml
    ``` 
    3. Arrancar la maquina
    ```
        virsh start debian10
    ```



### Crear discos (.qcow2, raw, etc)
Si decides crear primero el disco que se utilizara en la maquina virtual, en lugar de crearlo al mismo tiempo cuando se crea la VM, haremos lo siguiente:

```
    qemu-img create -f qcow2 /var/lib/libvirt/images/mi-disco.qcow2 20G
```
-f - especifica el formato del disco
    raw (default), tiene la ventaja de ser simple y facil de exportal para otros emuladores
    qcow2  Es el mas versatil, se usa para imagenes pequeñas
    qcow   Es el mas viejo de los anteriores
    (https://linux.die.net/man/1/qemu-img) 



# Comandos utiles
## Gestion de maquinas virtuales

* Listar VMs
```
    virsh list --all
```

* Encender
```
    virsh start vm1
```

* Apagar correctamente
```
    virsh shutdown vm1
```

* Forzar apagado
```
    virsh destroy vm1
```

* Conectarse por consola
```
    virsh console vm1 
```

* Ver XML de una VM
```
    virsh edit vm1 
```

* Tomar snapshot
```
    virsh snapshot-create-as vm1 snap1
```

## Gestion de redes
* Listar redes
```
    virsh net-list --all    
```

* Activar red 
```
    virsh net-start default
```

* Autoiniciar 
```
    virsh net-autostart default
```

* Crear red bridge para sacar la VM al LAN
```
    virsh net-create br0.xml
```


## Gestion de almacenamiento
* Ver pools  
```
    virsh pool-list --all
```

* Crear un volumen 
```
    virsh vol-create-as default debian.qcow2 20G --format qcow2
```



## Conexion a las maquinas virtuales
Para la conexion a las maquinas virtuales




-----
Bibliografias 

- (https://infotechys-com.translate.goog/create-a-virtual-machine-in-kvm-using-virt-install/?_x_tr_sl=en&_x_tr_tl=es&_x_tr_hl=es&_x_tr_pto=tc)
- (https://docs-redhat-com.translate.goog/en/documentation/red_hat_enterprise_linux/7/html/virtualization_deployment_and_administration_guide/sect-guest_virtual_machine_installation_overview-creating_guests_with_virt_install?_x_tr_sl=en&_x_tr_tl=es&_x_tr_hl=es&_x_tr_pto=tc)
- ( https://wiki.debian.org/es/libvirt )
- (https://fp.josedomingo.org/hlc2122/u01/introduccion.html)




