package runner;

import java.io.IOException;
import java.net.MalformedURLException;

import org.openqa.selenium.By;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.ui.Select;
import org.testng.annotations.AfterMethod;
import org.testng.annotations.BeforeMethod;
import org.testng.annotations.Test;

import com.aventstack.extentreports.ExtentReports;

import utils.Base;
import utils.ExcelReader;
import utils.LoggerHandler;
import utils.Reporter;
import utils.Screenshot;

public class TestSample extends Base {
   Reporter reporter;
   ExtentReports reports;
    @BeforeMethod
    public void launchBrowser() throws MalformedURLException {
        // launch your browser
        reports=reporter.generateExtentReport("Reports");
        driver=openBrowser();
    }

    @Test
    public void testOne() throws InterruptedException, IOException {
        // write or call ur pages here
        Thread.sleep(3000);
        driver.findElement(By.xpath("//input[@id='first_name']")).sendKeys("FirstName");
        String surname=ExcelReader.readdata("testdata/data.xlsx","Sheet1",0,0);
        Thread.sleep(4000);
        driver.findElement(By.xpath("//input[@id='last_name']")).sendKeys(surname);
        Thread.sleep(3000);
        driver.findElement(By.xpath("//input[@id='email']")).sendKeys("user002@email.com");
        Thread.sleep(3000);
        WebElement ele=driver.findElement(By.xpath("//select[@id='role_option']"));
        Select ss=new Select(ele);
        ss.selectByIndex(3);
        Thread.sleep(3000);
        WebElement elee=driver.findElement(By.xpath("//select[@id='country_option']"));
        Select sc=new Select(elee);
        sc.selectByIndex(0);
        Thread.sleep(3000);
        Screenshot.getScreenShot(driver, "screenshot");
        LoggerHandler.logInfo("Testcase passed");
    }

    @AfterMethod
    public void tearDown() {
        // quit the driver here
   driver.quit();
    }
}
