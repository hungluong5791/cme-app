package z8.art.keywords;

import java.util.Random;

import z8.art.aut.BaseTest;
import z8.art.common.Global;
import z8.art.common.Report;
import z8.art.dal.ExcelData;
import z8.art.object.KeywordInfo;

public class WebDemo extends BaseTest {
	
	@KeywordInfo(Description = "Open browser")
	public void OpenBrowser ()
	{
		navigate(Global.UAT_PATH);
	}

	@KeywordInfo(Description = "Input new account value")
	public void CreateNewAccount() {
		
		click("CreateAccount.CreatePage");
		Random a = new Random();
		String account = ExcelData.getCellText("Account Prefix")+a.nextInt(1000)+"@gmail.com";
		type("CreateAccount.Email",account);
		typeText("CreateAccount.Password","Password");
		typeText("CreateAccount.ConfirmPassword","ConfirmPassword");
		
		click("CreateAccount.SignUpButton");
		
	}
	
	@KeywordInfo(Description = "Verify account success")
	public void VerifyCreateAccount()
	{
		if (ExcelData.getCellText("Create account success").equals("Yes"))
		{
			if (getText("CreateAccount.LoginSuccess").contains(ExcelData.getCellText("Account Prefix").toUpperCase())) return;
			else Report.event("Check create account", Report.R_FAILED, "Account cannot create");
		}else
		{
			if (isExisted("CreateAccount.SignUpButton",5)) return;
			else Report.event("Check create account", Report.R_FAILED, "Account account created with wrong setting");
		}
	}
	
	@KeywordInfo(Description = "Close browser")
	public void CloseBrowser ()
	{
		closeDriver();
	}
}
