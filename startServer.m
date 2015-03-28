function startServer(output_port)

import java.net.ServerSocket
import java.io.*

global output_socket server_socket;

while true
    try
        fprintf(1, ['waiting for client to connect to this ' ...
            'host on port : %d\n'], output_port);
        
        % wait for 1 second for client to connect server socket
        server_socket = ServerSocket(output_port);
        server_socket.setSoTimeout(1000);
        
        output_socket = server_socket.accept;
        fprintf(1, 'Client connected\n');
        return;
    catch
        if ~isempty(server_socket)
            server_socket.close
        end
        
        if ~isempty(output_socket)
            output_socket.close
        end
        
        % pause before retrying
        pause(1);
    end
end
end