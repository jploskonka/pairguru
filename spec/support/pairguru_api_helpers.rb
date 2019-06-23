module PairguruApi
  module TestHelpers
    def stub_pairguru_get(path, fixture_file_name)
      stub_request(:get, path)
        .to_return(body: file_fixture(fixture_file_name).read,
                   headers: { "Content-Type" => "application/json; charset=utf-8" })
    end
  end
end
