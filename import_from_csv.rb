require 'sinatra'
require 'rack/handler/puma'
require 'pg'
require 'csv'

class Import
  def initialize
    @conn = PG.connect(host: 'postgres', dbname: 'postgres', user: 'postgres')
    @conn.exec("DROP TABLE IF EXISTS records")
    @conn.exec("CREATE TABLE records(
                id SERIAL PRIMARY KEY,
                registration_number VARCHAR(14) NOT NULL,
                name VARCHAR(100) NOT NULL,
                email VARCHAR(100) NOT NULL,
                birth_date DATE NOT NULL,
                address VARCHAR(200) NOT NULL,
                city VARCHAR(64) NOT NULL,
                state VARCHAR(64) NOT NULL,
                doctor_registration VARCHAR(10) NOT NULL,
                doctor_state VARCHAR(2) NOT NULL,
                doctor_name VARCHAR(100) NOT NULL,
                doctor_email VARCHAR(100) NOT NULL,
                token VARCHAR(6) NOT NULL,
                exam_date DATE NOT NULL,
                exam_type VARCHAR(50) NOT NULL,
                exam_limits VARCHAR(50) NOT NULL,
                exam_result VARCHAR(20) NOT NULL
                )")
    # @rows = CSV.read("./data.csv", col_sep: ';')
    # @conn.exec("COPY records(registration_number, name, email, birth_date, 
    #                         address, city, state, doctor_registration, doctor_state,
    #                         doctor_name, doctor_email, token, exam_date, 
    #                         exam_type, exam_limits, exam_result)
    #             FROM '#{@rows}'
    #             QUOTE E'\' 
    #             NULL AS ''
    #             CSV HEADER QUOTE")
    data_csv
  end
  def data_csv
    rows = CSV.read("./data.csv", col_sep: ';')
    rows.delete_at(0)
    rows.map do |row|
      @conn.exec("INSERT INTO records(registration_number, name, email, birth_date, 
                               address, city, state, doctor_registration, doctor_state,
                               doctor_name, doctor_email, token, exam_date, 
                               exam_type, exam_limits, exam_result)
                  VALUES('#{(row[0])}', '#{row[1]}', '#{row[2]}', '#{row[3]}', '#{row[4]}',
                  '#{@conn.escape_string(row[5])}','#{row[6]}', '#{row[7]}', '#{row[8]}', '#{row[9]}',
                  '#{row[10]}', '#{row[11]}', '#{row[12]}', '#{row[13]}',
                  '#{row[14]}', '#{row[15]}')")
    end
  end
end


