pragma solidity ^0.4.18;

contract Apuesta {
    //creamos enumerado
    enum Estado {sinApuesta, apuestaHecha, apuestaAceptada}
    
    Estado public estadoActual;
    
    uint public apostado;
    
    address public jugador1;
    address public jugador2;
    
    uint public numeroBloqueSemilla;
    
    function Apuesta () public{
        estadoActual = Estado.sinApuesta;
    }
    //comprobamos que estamos en el estado que queremos
    modifier soloEstado(Estado estadoEsperado) {
        require(estadoEsperado == estadoActual);
        _;
    }
    
    function apostar () public soloEstado(Estado.sinApuesta) payable {
        apostado = msg.value;
        jugador1 = msg.sender;
        estadoActual = Estado.apuestaHecha;
    }
    
    function aceptarApuesta () public soloEstado (Estado.apuestaHecha) payable {
        //los require son importantes ya que van a deshacer el estado completamente
        //esto para no perder los ether en una transaccion no valida
        require(msg.value == apostado);
        
        numeroBloqueSemilla = block.number; //guarda numero de bloque
        
        jugador2 = msg.sender;
        estadoActual = Estado.apuestaAceptada;
    }
    
    function resolverApuesta () public soloEstado (Estado.apuestaAceptada){
        //con block.blockhash le podemos pasar el numero de bloque y devuelve el
        //hash de ese bloque donde se esta tomando en cuenta no solo numero de 
        //bloques si no transacciones que se han echo etc.
        // tomamos el numero de bloque de la transaccion anterior pedimos el
        //blockhash y lo transformamos a uint256
        uint256 bloque = uint256(block.blockhash(numeroBloqueSemilla));
        uint256 halfValue = (2**255);
        uint256 flip = uint256(uint256(bloque) / halfValue);
        
        estadoActual = Estado.sinApuesta;
        if (flip == 0) {
            jugador1.transfer(this.balance);
        } else {
            jugador2.transfer(this.balance);
        }
        
        
    }
