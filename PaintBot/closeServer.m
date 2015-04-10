function closeServer()

import java.net.ServerSocket
import java.io.*
global output_socket server_socket;
try
    server_socket.close;
    output_socket.close;
catch
end
end