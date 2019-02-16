﻿using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Threading.Tasks;
using System.Xml.Serialization;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Logging;
using NLog;
using LogLevel = NLog.LogLevel;
using Software.Model.Models;
using System.Text;
using Microsoft.AspNetCore.WebUtilities;
using System.Threading;
using Microsoft.AspNetCore.Mvc.Formatters;

namespace Software.WebApi.Filter
{
    /// <summary>
    /// 全局异常拦截器
    /// </summary>
    public class ErrorHandlingMiddleware
    {
        private readonly RequestDelegate next;
        private readonly ILogger<ErrorHandlingMiddleware> _logger;
        private readonly IHostingEnvironment _env;
        private static readonly Logger Logger = LogManager.GetCurrentClassLogger();

        public ErrorHandlingMiddleware(RequestDelegate next, ILogger<ErrorHandlingMiddleware> logger, IHostingEnvironment env)
        {
            this.next = next;
            _logger = logger;
            _env = env;
        }
        public async Task Invoke(HttpContext context)
        {
            try
            {
                await next(context);
            }
            catch (Exception ex)
            {
                await HandleExceptionAsync(context, ex, _env.IsDevelopment());
                //记录日志
                _logger.LogError(FormatMessage(ex.Message, ex, context));

            }
        }

        private static async Task HandleExceptionAsync(HttpContext context, Exception exception, bool isDevelopment)
        {
            if (exception == null) return;
            await WriteExceptionAsync(context, exception, isDevelopment).ConfigureAwait(false);
        }

        private static async Task WriteExceptionAsync(HttpContext context, Exception exception, bool isDevelopment)
        {
            var result = JsonConvert.SerializeObject(new Result<string>() { status = false, message = (isDevelopment ? exception.ToString() : exception.Message) });

            //返回友好的提示
            var response = context.Response;

            //状态码
            if (exception is UnauthorizedAccessException)
                response.StatusCode = (int)HttpStatusCode.Unauthorized;
            //else if (exception is Exception)
            //    response.StatusCode = (int)HttpStatusCode.InternalServerError;

            response.ContentType = context.Request.Headers["Accept"];

            if (response.ContentType.ToLower() == "application/xml")
            {
                await response.WriteAsync(result).ConfigureAwait(false);
            }
            else
            {
                response.ContentType = "application/json";
                await response.WriteAsync(result).ConfigureAwait(false);
            }
        }


        /// <summary>
        /// 自定义返回格式
        /// </summary>
        /// <param name="throwMsg"></param>
        /// <param name="ex"></param>
        /// <returns></returns>
        public static string FormatMessage(string throwMsg, Exception ex, HttpContext context)
        {
            var request = context.Request;
            LogEventInfo ei = new LogEventInfo(LogLevel.Error, "LoggerName", "Message");
            ei.Level = LogLevel.Fatal;
            ei.Properties["Path"] = request.Path;

            var param = string.Empty;
            if (request.Method.ToLower() == "get")
            {
                param = JsonConvert.SerializeObject(request.Query);
            }
            else if (request.Method.ToLower() == "post")
            {
                if (context.Request.ContentLength != 0)
                {
                    using (StreamReader reader = new StreamReader(request.Body, Encoding.UTF8))
                    {
                        request.Body.Position = 0;//重新设置数据流的起始位置
                        param = reader.ReadToEnd();
                    }
                }
            }
            ei.Properties["Query"] = param;
            ei.Properties["Message"] = ex.Message.ToString();
            ei.Message = ex.Message.ToString();
            Logger.Log(ei);

            return $@"【异常信息】：{ex.Message}
                      【异常类型】：{ ex.GetType().Name}
                      【接口地址】：{request.Path}
                      【接口参数】：{param}
                      【堆栈调用】：{ex.StackTrace}";

        }


        /// <summary>
        /// 对象转为Xml
        /// </summary>
        /// <param name="o"></param>
        /// <returns></returns>
        private static string Object2XmlString(object o)
        {
            StringWriter sw = new StringWriter();
            try
            {
                XmlSerializer serializer = new XmlSerializer(o.GetType());
                serializer.Serialize(sw, o);
            }
            catch
            {
                //Handle Exception Code
            }
            finally
            {
                sw.Dispose();
            }
            return sw.ToString();
        }
    }

    /// <summary>
    /// 自定义拦截器
    /// </summary>
    public static class ErrorHandlingExtensions
    {
        /// <summary>
        /// 错误拦截
        /// </summary>
        /// <param name="builder"></param>
        /// <returns></returns>
        public static IApplicationBuilder UseErrorHandling(this IApplicationBuilder builder)
        {
            return builder.UseMiddleware<ErrorHandlingMiddleware>();
        }
    }
}
