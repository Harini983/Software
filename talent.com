package pages;

import java.io.IOException;
import java.nio.charset.MalformedInputException;

import org.openqa.selenium.WebDriver;

import com.aventstack.extentreports.ExtentReports;
import com.aventstack.extentreports.ExtentTest;

import uistore.TalentLocators;
import utils.ExcelReader;
import utils.Screenshot;
import utils.WebDriverHelper;

public class Talent {
   
    WebDriverHelper helper;
    ExtentTest test;
    String name1;
    String email1;
    String password;
    WebDriver driver;


    public Talent(WebDriver driver, ExtentReports report){
        this.driver = driver;
        helper =new WebDriverHelper(driver);
        test =report.createTest("talent");
       
    }

    public void sample() throws IOException{
       

            helper.clickOnElement(TalentLocators.apply);
            helper.clickOnElement(TalentLocators.developer);
   
            try {
                name1 =ExcelReader.readdata("testdata/Data.xlsx","Sheet1", 0,0);
                helper.sendKeys(TalentLocators.name,name1);
                email1=ExcelReader.readdata("testdata/Data.xlsx","Sheet1",1,0);
                helper.sendKeys(TalentLocators.email, email1);
                password=ExcelReader.readdata("testdata/Data.xlsx","Sheet1",2,0);
            } catch (IOException e) {
                e.printStackTrace();
            }

            helper.clickOnElement(TalentLocators.button);
            String screenshotPath = Screenshot.getScreenShot(driver, "Screenshot");
            test.addScreenCaptureFromPath(screenshotPath);
        }
       
    }
package runner;

import java.io.IOException;
import java.net.MalformedURLException;

import org.testng.annotations.AfterClass;
import org.testng.annotations.AfterMethod;
import org.testng.annotations.BeforeClass;
import org.testng.annotations.BeforeMethod;
import org.testng.annotations.Test;

import com.aventstack.extentreports.ExtentReports;

import pages.Talent;
import utils.Base;
import utils.Reporter;
public class TestRunner extends Base {

    Talent talent;
    ExtentReports report;

    @BeforeClass
    public void before(){
        report =Reporter.generateExtentReport("Extend report");

    }

  @BeforeMethod
    public void launchBrowser() {
        try{
            openBrowser();
        }
        catch(MalformedURLException e){
             System.out.println(e.getMessage());

        }
        talent =new Talent(driver,report);
    }

    @Test
    public void testOne() throws IOException {
        talent.sample();
    }
    @AfterMethod
    public void tearDown() {
        driver.quit();
    }
    @AfterClass
    public void after(){
        report.flush();
    }
}
package uistore;

import org.openqa.selenium.By;

public class TalentLocators {

    public static By apply =By.xpath("//*[@id=\"talent-apply-form\"]/div[1]/div/div");

    public static By developer =By.xpath("//*[@id=\"talent-apply-form\"]/div[1]/div/ul/li[1]/div/div/span");
     public static By name =By.xpath("//*[@id=\"talent_create_applicant[fullName]\"]");
     public static By email =By.xpath("//*[@id=\"talent_create_applicant[email]\"]");


    public static By button =By.xpath("//*[@id=\"talent-apply-form\"]/button");
   
}
