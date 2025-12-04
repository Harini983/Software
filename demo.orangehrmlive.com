pages/TestCase1.java
package pages;

import java.io.IOException;

import org.openqa.selenium.WebDriver;

import uistore.locator;
import utils.LoggerHandler;
import utils.Screenshot;
import utils.WebDriverHelper;

public class TestCase1 {
   
    WebDriverHelper helper;
    WebDriver driver;

    public TestCase1(WebDriver driver){
        helper = new WebDriverHelper(driver);
        this.driver = driver;

    }

    public void test1() throws IOException{
        helper.sendKeys(locator.username, "Admin");
        helper.sendKeys(locator.pass, "admin123");
        helper.clickOnElement(locator.login);
        Screenshot.getScreenShot(driver, "screenshot");
        LoggerHandler.logInfo("INFO");
       

    }
}
runner/TestSample.java
package runner;

import java.io.IOException;
import java.net.MalformedURLException;

import org.testng.annotations.AfterMethod;
import org.testng.annotations.AfterSuite;
import org.testng.annotations.BeforeMethod;
import org.testng.annotations.BeforeSuite;
import org.testng.annotations.Test;

import com.aventstack.extentreports.ExtentReports;
import com.aventstack.extentreports.model.Report;

import pages.TestCase1;
import utils.Base;
import utils.Reporter;

public class TestSample extends Base{

    TestCase1 test_case1;
    ExtentReports report;

    @BeforeSuite
    public void openReport(){
        report = Reporter.generateExtentReport("/report");
    }

    @BeforeMethod
    public void launchBrowser() throws MalformedURLException {
        openBrowser();
        test_case1 = new TestCase1(driver);
    }

    @Test
    public void testOne() throws IOException {
        test_case1.test1();
    }

    @AfterMethod
    public void tearDown() {
        if(driver != null){
            driver.quit();
        }
    }

    @AfterSuite
    public void closeReport(){
        report.flush();
    }
}

uistore/locator.java
package uistore;

import org.openqa.selenium.By;

public class locator{
    public static final By username = By.xpath("//*[@id=\"app\"]/div[1]/div/div[1]/div/div[2]/div[2]/form/div[1]/div/div[2]/input");
    public static final By pass = By.xpath("//*[@id='app']/div[1]/div/div[1]/div/div[2]/div[2]/form/div[2]/div/div[2]/input");
    public static final By login = By.xpath("//*[@id='app']/div[1]/div/div[1]/div/div[2]/div[2]/form/div[3]/button");
}
