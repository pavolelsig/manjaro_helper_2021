# Passthrough Helper 2021 for Manjaro

Passthrough helper for Manjaro simplifies installing required packages and sets up your PC to run virtual machines with GPU passthrough. <br/>
*AMD and Intel (including 12th generation Alder Lake) systems are supported<br/>
*Nvidia, AMD, and Intel GPUs are supported<br/>

# Tutorial
For a tutorial, go here:<br/>

# Performance optimizations
```

  <features>
    <acpi/>
    <apic/>
    <hyperv>
      <relaxed state="on"/>
      <vapic state="on"/>
      <spinlocks state="on" retries="4096"/>
      <vpindex state="on"/>
      <runtime state="on"/>
      <synic state="on"/>
      <stimer state="on">
        <direct state="on"/>
      </stimer>
      <reset state="on"/>
      <frequencies state="on"/>
      <reenlightenment state="on"/>
    </hyperv>
    <vmport state="off"/>
  </features>
```

_______________________________________________________________
# CPU core pinning
```
  <vcpu placement="static">8</vcpu>
  <iothreads>1</iothreads>
  <cputune>
    <vcpupin vcpu="0" cpuset="0"/>
    <vcpupin vcpu="1" cpuset="1"/>
    <vcpupin vcpu="2" cpuset="2"/>
    <vcpupin vcpu="3" cpuset="3"/>
    <vcpupin vcpu="4" cpuset="4"/>
    <vcpupin vcpu="5" cpuset="5"/>
    <vcpupin vcpu="6" cpuset="6"/>
    <vcpupin vcpu="7" cpuset="7"/>
    <emulatorpin cpuset="16-17"/>
    <iothreadpin iothread="1" cpuset="18-19"/>
  </cputune>
  <os>

  <cpu mode="host-passthrough" check="none" migratable="on">
    <topology sockets="1" dies="1" cores="8" threads="1"/>
  </cpu>
  
```
__________________________________________________________________
# AMD GPU hypervisor detection
```
  <hyperv>
    
    <vendor_id state='on' value='notavm'/>
    
  </hyperv>
_______________________________________________________________
```
  
# Sources
* https://wiki.archlinux.org/index.php/PCI_passthrough_via_OVMF#Using_identical_guest_and_host_GPUs
