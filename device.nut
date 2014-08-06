rts <- hardware.pin5;
uart <- hardware.uart12;
tx <- hardware.pin1;

// initialise a 512-device DMX frame
local outBlob = blob(512);
for (local i = 0; i < outBlob.len(); i++) {
  outBlob.writen(0, 'b');
}

function setLevel(addr, level) {
  // send DMX512 command to set device at "addr"
  outBlob.seek(addr);
  outBlob.writen(level, 'b');
  // the frame will automatically be sent on the next refresh
}

function refresh() {
  // manually send out the break and mark-after-break
  tx.configure(DIGITAL_OUT, 0);
  imp.sleep(0.0001);

  // mark-after-break is implicitly sent here; bus idles high while we configure the UART in SW
  uart.configure(250000, 8, PARITY_NONE, 2, NO_CTSRTS);
  
  uart.write(outBlob); // send the frame
  imp.wakeup(0.1, refresh); // schedule next refresh
}

// ----- main program -----
server.log("DMX - " + imp.getsoftwareversion());
server.log(imp.getmacaddress());

rts.configure(DIGITAL_OUT);
rts.write(1);
refresh();

// Convert hex string to an integer
function Hex2Num(hex)
{
server.log("h2nIn"+hex)
    local result = 0;
    local shift = hex.len() * 4;
 
    // For each digit..
    for(local d=0; d<hex.len(); d++)
    {
        local digit;
 
        // Convert from ASCII Hex to integer
        if(hex[d] >= 0x61)
            digit = hex[d] - 0x57;
        else if(hex[d] >= 0x41)
             digit = hex[d] - 0x37;
        else
             digit = hex[d] - 0x30;
 
        // Accumulate digit
        shift -= 4;
        result += digit << shift;
    }
 
    return result;
}




//setLevel(6,16); 
setLevel(1,255); 
setLevel(2,206); 
setLevel(3,114); 
setLevel(4,65); 
//setLevel(7,50); 

agent.on("favcolor", function (value) {
//server.log(value.slice(1,7));
setLevel(2,Hex2Num(value.slice(1,3))); 
setLevel(3,Hex2Num(value.slice(3,5))); 
setLevel(4,Hex2Num(value.slice(5,7))); 


//server.log(Hex2Num(value.slice(1,3)));   
//server.log(Hex2Num(value.slice(3,5)));   
//server.log(Hex2Num(value.slice(5,7)));
    
});