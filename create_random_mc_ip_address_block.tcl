### Create a random MC address block
### Generate an initial random multicast address - minAddr
### Generate the final multicast address that is "block" addresses away
### Example: If initial address is 224.0.0.10, block was 100 - the proc 
### would return "224.0.0.10 224.0.0.110"
proc create_random_mc_ip_address_block { block } {
    set firstOctet  [expr {int(rand()*140)} + 224]

    ### Lets ignore 232 for the time being, 232.0.0.0 to 232.255.255.255 is reserved
    if { $firstOctet == 232 } {
        set firstOctet 239
    }
    set secondOctet [expr {int(rand()*255)}]
    set thirdOctet  [expr {int(rand()*255)}]
    set fourthOctet [expr {int(rand()*255)}]

    set minMcAddr "$firstOctet.$secondOctet.$thirdOctet.$fourthOctet"

    while { $block > 0 } { 
        if { [expr $fourthOctet + $block] > 255 } { 
            set block [expr $fourthOctet + $block - 255]
        
            if { $thirdOctet < 255 } { 
                incr thirdOctet
                set fourthOctet 0
            } elseif { $secondOctet < 255 } {
                incr secondOctet
                set  thirdOctet 0
            } else {
                incr firstOctet
                set secondOctet 0
            }
        } else {
            set fourthOctet [expr $fourthOctet + $block]
            set block 0
        }
    }
         
    set maxMcAddr "$firstOctet.$secondOctet.$thirdOctet.$fourthOctet"

    return "$minMcAddr $maxMcAddr"

#   puts "minMcAddr: $minMcAddr, maxMcAddr: $maxMcAddr"
}

