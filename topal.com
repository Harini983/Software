package runner;

import java.net.MalformedURLException;
import java.net.URL;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeOptions;
import org.openqa.selenium.remote.RemoteWebDriver;
import org.openqa.selenium.support.events.EventFiringDecorator;
import org.openqa.selenium.support.events.WebDriverListener;
import org.testng.annotations.AfterClass;
import org.testng.annotations.AfterMethod;
import org.testng.annotations.BeforeClass;
import org.testng.annotations.BeforeMethod;
import org.testng.annotations.Test;

import com.aventstack.extentreports.ExtentReports;
import com.aventstack.extentreports.reporter.ExtentSparkReporter;
import com.aventstack.extentreports.reporter.configuration.Theme;

import utils.Base;
import utils.EventHandler;
import utils.ExcelReader;
import utils.LoggerHandler;
import utils.Screenshot;

public class TestSample extends Base{

    public static Screenshot screenshot;
    ExtentReports reports;
    ExtentSparkReporter spark;
    @BeforeClass
    public void getReports(){
        reports = new ExtentReports();
        spark = new ExtentSparkReporter("reports/myReport.html");
        spark.config().setTheme(Theme.DARK);
        spark.config().setDocumentTitle("Orange HRM report");

        if(reports != null) {
            reports.attachReporter(spark);
        }

   
    }

    @BeforeMethod
    public void launchBrowser() throws MalformedURLException {
        openBrowser();
    }

    @Test
    public void testOne() {
        try{
            Thread.sleep(3000);
            driver.findElement(By.xpath("//div[@class='_1WRJuyTt _3dVVljYP _2FR6nyQk']")).click();
            Thread.sleep(3000);
            driver.findElement(By.xpath("//div[@class='_26cjR6gi']")).click();
            LoggerHandler.logInfo("clicked succesfully");
            String username=ExcelReader.readdata("testdata/data.xlsx","Sheet1",0,0);
            driver.findElement(By.xpath("//input[@class='_3MuNYYSt']")).sendKeys(username);
            driver.findElement(By.xpath("//input[@name='email']")).sendKeys("Email@email.com");
            Thread.sleep(2000);
            driver.findElement(By.xpath("//input[@name='password']")).sendKeys("password@007");
            Thread.sleep(20000);
            driver.findElement(By.xpath("//button[@class='box-border border-0 border-solid font-family-inherit m-0 p-0 text-center inline-flex items-center justify-center rounded-md outline-none focus-visible:ring-4 focus-visible:ring-brand-blue/50 font-semibold disabled:pointer-events-none cursor-pointer disabled:cursor-default transition-colors text-white bg-brand-green disabled:bg-gray-300 hover:bg-brand-green-dark active:bg-brand-green-darker paragraph-md gap-6 py-[14px] px-[33px] md:px-[49px] _234usIAX']")).click();
           
            Screenshot.getScreenShot(driver, "screenshot");
        }
        catch(Exception e)
        {
            e.printStackTrace();
        }


    }

    @AfterMethod
    public void tearDown() {
        driver.quit();
    }

    @AfterClass
    public void finalReports(){
        if(reports != null) {
            reports.flush();
        }
    }
}
