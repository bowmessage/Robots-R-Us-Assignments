function startClient(host, port)
import java.net.Socket
import java.io.*
global input_socket input_stream d_input_stream;
while true
    
    try
        fprintf(1, 'Retry connecting to %s:%d\n', ...
            host, port);
        
        % throws if unable to connect
        input_socket = Socket(host, port);
        
        % get a buffered data input stream from the socket
        input_stream   = input_socket.getInputStream;
        d_input_stream = DataInputStream(input_stream);
        
        fprintf(1, 'Connected to server\n');
        
        
        
        % cleanup
        
        break;
        
    catch
        % pause before retrying
        pause(1);
    end
end
end