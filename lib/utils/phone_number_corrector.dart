String checkPhoneNumber(String phoneNumber) {
  //* if phone number starts with '+251' then return the phone number itself
  if (phoneNumber.substring(0, 4) == "+251" && phoneNumber.length == 13) {
    return phoneNumber;
  }
  //* else if the phone number starts with '0' then cut the 0 out and add '+251' then return
  else if (phoneNumber.substring(0, 1) == "0" && phoneNumber.length == 10) {
    return "+251" + phoneNumber.substring(1);
  }
  //* else if the phone number starts with '9' then add '+251' then return
  else if (phoneNumber.substring(0, 1) == "9" && phoneNumber.length == 9) {
    return "+251" + phoneNumber;
  }
  //* else return error string
  else {
    return "error";
  }
}
