package runner;

import java.io.IOException;
import java.net.MalformedURLException;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.testng.annotations.AfterClass;
import org.testng.annotations.AfterMethod;
import org.testng.annotations.BeforeClass;
import org.testng.annotations.BeforeMethod;
import org.testng.annotations.Test;

import com.aventstack.extentreports.ExtentReports;
import com.aventstack.extentreports.reporter.ExtentSparkReporter;

import utils.Base;
import utils.LoggerHandler;
import utils.Screenshot;
public class TestSample extends Base{

    WebDriver driver;
    public static Screenshot screenshot;
    ExtentReports reports;
   
    @BeforeClass
    public void generateReport(){
        reports = new ExtentReports();
        ExtentSparkReporter spark = new ExtentSparkReporter("reports/myReport.html");
        spark.config().setDocumentTitle("Report");
        reports.attachReporter(spark);
    }

    @BeforeMethod
    public void launchBrowser() throws MalformedURLException {
        driver = openBrowser();
        // launch your browser
        //screenshot = new Screenshot();
        driver.get("https://dashboard.stripe.com/login");
    }

    @Test
    public void testOne() throws IOException {
        // write or call ur pages here
        driver.findElement(By.id("email")).sendKeys("user001@email.com");
        driver.findElement(By.name("password")).sendKeys("password321");
        driver.findElement(By.xpath("//span[text() = 'Sign in']")).click();
        screenshot.getScreenShot(driver,"screenshot");
        LoggerHandler.logInfo("Logs generated");
        driver.findElement(By.xpath("//span[text() = 'Forgot your password?']")).click();

    }

    @AfterMethod
    public void tearDown() {
        // quit the driver here
        driver.quit();
    }

    @AfterClass
    public void flushreport(){
        reports.flush();
    }
}
