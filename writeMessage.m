function writeMessage(message)
global output_socket server_socket;
output_stream   = output_socket.getOutputStream;
d_output_stream = DataOutputStream(output_stream);

% output the data over the DataOutputStream
% Convert to stream of bytes
fprintf(1, 'Writing %d bytes\n', length(message))
d_output_stream.writeBytes(char(message));
d_output_stream.flush;

end