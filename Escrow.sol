pragma solidity ^0.4.18;

//Este contrato es para controlar los medios de pago, cuando el usuario quiere comprar
//algo que le interesa manda la solicitud de pago, despues se envia los datos de pago
// y es aqui donde entra este contrato, cuando el usuario paga, ese dinero no se libera
//hasta que el usario comprador da el visto bueno, mientras el dinero no se libera.
//en caso de que hubiera una disputa entra un intermediario que tomara la decision
contract Escrow {
    
    address public comprador;
    address public vendedor;
    address public arbitro;
    
    //contructor
    function Escrow(address _vendedor, address _arbitro) public {
        comprador = msg.sender; //declaramos quien genera la llamada
        vendedor = _vendedor;
        arbitro = _arbitro;
    }
    
    //payable quiere decir que este metodo puede recibir un valor atravez de la trasaccion
    //osea que se le puedes pagar
    //funcion para comprar
    function purchase () public payable {
        //comprobamos que el que esta enviando la transaccion sea el comprador
        require (msg.sender == comprador);
    }
    
    function obtenerBalance () public constant returns (uint){
        return this.balance;
    }
    //obtener la direccion del contrato
    function obtenerDireccion () public constant returns (address){
        return this;
    }
    
    function pagarAlVendedor () public {
        //verificamos que si el comprador esta de acuerdo con lo que ha recibido para
        //proceder a pagar o ya sea que decida el intermediario
        if(msg.sender == comprador || msg.sender == arbitro){
            vendedor.transfer(this.balance);
        }
    }
    
    function devolverAlComprador () public {
        if (msg.sender == vendedor || msg.sender == arbitro){
            comprador.transfer(this.balance);
        }
    }
    
}
