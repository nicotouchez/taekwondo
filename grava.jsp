<%@ page import="java.sql.*" %>
<%
    // Obtendo os dados do formulário
    String nome = request.getParameter("nome");
    String email = request.getParameter("email");
    String telefone = request.getParameter("telefone");
    String dataNascimento = request.getParameter("data_nascimento");
    String aulaId = request.getParameter("aula_id");

    // Configuração da conexão com o banco de dados
    String url = "jdbc:mysql://localhost:3306/taekwondo_db?useSSL=false&serverTimezone=UTC"; 
    String usuario = "root"; // Usuário padrão no XAMPP
    String senha = ""; // Senha vazia no XAMPP (não tem senha por padrão)

    // Variáveis de conexão
    Connection conn = null;
    PreparedStatement stmt = null;
    String sql = "INSERT INTO Agendamentos (UsuarioID, AulaID) VALUES (?, ?)";

    try {
        // Carregando o driver JDBC do MySQL
        Class.forName("com.mysql.jdbc.Driver");

        // Estabelecendo a conexão com o banco de dados
        conn = DriverManager.getConnection(url, usuario, senha);

        // Inserindo o novo usuário (caso não exista)
        String insertUserSql = "INSERT INTO Usuarios (Nome, Email, Telefone, DataNascimento) VALUES (?, ?, ?, ?)";
        PreparedStatement insertUserStmt = conn.prepareStatement(insertUserSql, Statement.RETURN_GENERATED_KEYS);
        insertUserStmt.setString(1, nome);
        insertUserStmt.setString(2, email);
        insertUserStmt.setString(3, telefone);
        insertUserStmt.setString(4, dataNascimento);
        insertUserStmt.executeUpdate();  // Executa o INSERT

        // Recuperando a chave gerada (ID do usuário)
        ResultSet rs = insertUserStmt.getGeneratedKeys();
        int usuarioId = 0;
        if (rs.next()) {
            usuarioId = rs.getInt(1); // Obtendo o ID gerado automaticamente
        }

        // Inserindo o agendamento
        stmt = conn.prepareStatement(sql);
        stmt.setInt(1, usuarioId);  // Usando o ID do usuário gerado
        stmt.setInt(2, Integer.parseInt(aulaId)); // ID da aula escolhida
        stmt.executeUpdate(); // Executando a inserção do agendamento

        out.println("Aula agendada com sucesso!");

    } catch (SQLException e) {
        out.println("Erro ao agendar a aula: " + e.getMessage());
    } catch (ClassNotFoundException e) {
        out.println("Driver JDBC não encontrado: " + e.getMessage());
    } finally {
        try {
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            out.println("Erro ao fechar a conexão: " + e.getMessage());
        }
    }
%>
