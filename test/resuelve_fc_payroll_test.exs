defmodule ResuelveFCPayrollTest do
  use ExUnit.Case
  import ExUnit.CaptureLog
  # doctest ResuelveFCPayroll

  describe "ResuelveFCPayroll.main/1" do
    test "return payroll data" do
      assert {:ok, true} == ResuelveFCPayroll.main(["{\"name\": \"Vincent\"}"])
    end

    test "return error if no arguments are supplied" do
      {_result, log} = with_log(&ResuelveFCPayroll.main/0)
      assert log =~ "No argument supplied."
    end

    test "return error if --json argument can't be parsed" do
      {_result, log} = with_log(fn -> ResuelveFCPayroll.main(["malformed_json"]) end)
      assert log =~ "Unable to read JSON data."
    end
  end
end
